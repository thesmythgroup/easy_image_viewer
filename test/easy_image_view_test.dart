import 'package:easy_image_viewer/src/easy_image_view.dart';

import 'support/test_helper.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EasyImageView', () {
    testWidgets('should have an image and a scale',
        (WidgetTester tester) async {
      ImageProvider? imageProvider;

      await tester.runAsync(() async {
        imageProvider = await createColorImage(Colors.green);
      });

      Widget testWidget = MediaQuery(
          data: const MediaQueryData(size: Size(600, 800)),
          child: EasyImageView(
              imageProvider: imageProvider!, minScale: 0.5, maxScale: 6.0));

      await tester.pumpWidget(testWidget);

      // Create the Finders.
      final sizedBoxFinder = find.byKey(const Key('easy_image_sized_box'));
      final interactiveViewFinder =
          find.byKey(const Key('easy_image_interactive_viewer'));
      final imageFinder = find.image(imageProvider!);

      // Check existence
      expect(sizedBoxFinder, findsOneWidget);
      expect(interactiveViewFinder, findsOneWidget);
      expect(imageFinder, findsOneWidget);

      // Check properties
      SizedBox sizedBox = tester.firstWidget(sizedBoxFinder);
      expect(sizedBox.width, double.infinity);
      expect(sizedBox.height, double.infinity);
      InteractiveViewer interactiveViewer =
          tester.firstWidget(interactiveViewFinder);
      expect(interactiveViewer.minScale, 0.5);
      expect(interactiveViewer.maxScale, 6.0);
    });

    testWidgets(
        'should invoke the onScaleChanged callback when pinching out (doubleTapZoomable false)',
        (WidgetTester tester) async {
      ImageProvider? imageProvider;

      double lastScale = 1.0;

      await tester.runAsync(() async {
        imageProvider = await createColorImage(Colors.green);
      });

      Widget testWidget = MediaQuery(
          data: const MediaQueryData(size: Size(600, 800)),
          child: EasyImageView(
              imageProvider: imageProvider!,
              minScale: 0.5,
              maxScale: 6.0,
              onScaleChanged: (scale) {
                lastScale = scale;
              }));

      await tester.pumpWidget(testWidget);

      // Create the finder
      final interactiveViewFinder = find.byType(InteractiveViewer);

      // Get the center
      final center = tester.getCenter(interactiveViewFinder);

      // Zoom in:
      final Offset scaleStart1 = center;
      final Offset scaleStart2 = Offset(center.dx + 10.0, center.dy);
      final Offset scaleEnd1 = Offset(center.dx - 10.0, center.dy);
      final Offset scaleEnd2 = Offset(center.dx + 10.0, center.dy);
      final TestGesture gesture = await tester.createGesture();
      final TestGesture gesture2 = await tester.createGesture();
      await gesture.down(scaleStart1);
      await gesture2.down(scaleStart2);
      await tester.pump();
      await gesture.moveTo(scaleEnd1);
      await gesture2.moveTo(scaleEnd2);
      await tester.pump();
      await gesture.up();
      await gesture2.up();
      await tester.pumpAndSettle();

      expect(lastScale, greaterThan(1));
    });

    testWidgets(
        'should invoke the onScaleChanged callback when pinching out (doubleTapZoomable true)',
        (WidgetTester tester) async {
      ImageProvider? imageProvider;

      double lastScale = 1.0;

      await tester.runAsync(() async {
        imageProvider = await createColorImage(Colors.green);
      });

      Widget testWidget = MediaQuery(
          data: const MediaQueryData(size: Size(600, 800)),
          child: EasyImageView(
              imageProvider: imageProvider!,
              minScale: 0.5,
              maxScale: 6.0,
              doubleTapZoomable: true,
              onScaleChanged: (scale) {
                lastScale = scale;
              }));

      await tester.pumpWidget(testWidget);

      // Create the finder
      final interactiveViewFinder = find.byType(InteractiveViewer);

      // Get the center
      final center = tester.getCenter(interactiveViewFinder);

      // Zoom in:
      final Offset scaleStart1 = center;
      final Offset scaleStart2 = Offset(center.dx + 10.0, center.dy);
      // When doubleTapZoomable is true, we need a bigger "pinch" because the
      // GestureRecognizer captures the first millimeters of the pinch
      // before passing it on to the InteractiveViewer.
      final Offset scaleEnd1 = Offset(center.dx - 50.0, center.dy);
      final Offset scaleEnd2 = Offset(center.dx + 50.0, center.dy);
      final TestGesture gesture = await tester.createGesture();
      final TestGesture gesture2 = await tester.createGesture();
      await gesture.down(scaleStart1);
      await gesture2.down(scaleStart2);
      await tester.pump();
      await gesture.moveTo(scaleEnd1);
      await gesture2.moveTo(scaleEnd2);
      await tester.pump();
      await gesture.up();
      await gesture2.up();
      await tester.pumpAndSettle();

      expect(lastScale, greaterThan(1));
    });

    testWidgets(
        'should invoke the onScaleChanged callback when double tapping to zoom',
        (WidgetTester tester) async {
      ImageProvider? imageProvider;

      double lastScale = 1.0;

      await tester.runAsync(() async {
        imageProvider = await createColorImage(Colors.green);
      });

      Widget testWidget = MediaQuery(
          data: const MediaQueryData(size: Size(600, 800)),
          child: EasyImageView(
              imageProvider: imageProvider!,
              minScale: 0.5,
              maxScale: 6.0,
              doubleTapZoomable: true,
              onScaleChanged: (scale) {
                lastScale = scale;
              }));

      await tester.pumpWidget(testWidget);

      // Create the finder
      final interactiveViewFinder = find.byType(InteractiveViewer);

      // Get the center
      final center = tester.getCenter(interactiveViewFinder);

      final Offset scaleStart1 = center;

      final TestGesture gesture = await tester.createGesture();

      // double tap
      await gesture.down(scaleStart1);
      await gesture.up();
      await tester.pump(const Duration(milliseconds: 200));
      await gesture.down(scaleStart1);
      await gesture.up();
      await tester.pumpAndSettle();

      expect(lastScale, 2.0);
    });
  });
}
