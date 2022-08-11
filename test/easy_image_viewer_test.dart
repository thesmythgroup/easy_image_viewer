import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_helper.dart';

void main() {
  group('showImageViewer', () {
    testWidgets(
        'should have a PageView of images and invoke dismissal callback',
        (WidgetTester tester) async {
      ImageProvider? redImageProvider;
      BuildContext context = await createTestBuildContext(tester);
      bool dismissed = false;

      await tester.runAsync(() async {
        redImageProvider = await createColorImage(Colors.red);
      });

      final dialogFuture =
          showImageViewer(context, redImageProvider!, onViewerDismissed: () {
        dismissed = true;
      });
      await tester.pumpAndSettle();

      // Create the Finders.
      final pageViewFinder =
          find.byWidgetPredicate((widget) => widget is PageView);
      final closeButtonFinder = find.byIcon(Icons.close);

      // Check existence
      expect(pageViewFinder, findsOneWidget);
      expect(closeButtonFinder, findsOneWidget);

      // Dismiss the dialog
      await tester.tap(closeButtonFinder);

      await dialogFuture;

      expect(dismissed, true);
    });

    testWidgets('should respect the backgroundColor and closeButtonColor',
        (WidgetTester tester) async {
      late ImageProvider imageProvider;
      final context = await createTestBuildContext(tester);

      await tester.runAsync(() async {
        imageProvider = await createColorImage(Colors.amber);
      });

      showImageViewer(context, imageProvider,
          backgroundColor: Colors.red, closeButtonColor: Colors.green);
      await tester.pumpAndSettle();

      // Check default closeButtonColor
      IconButton closeButton =
          tester.firstWidget(find.widgetWithIcon(IconButton, Icons.close));
      expect(closeButton.color, Colors.green);

      // Check default dialog backgroundColor
      Dialog dialog = tester
          .firstWidget(find.byWidgetPredicate((widget) => widget is Dialog));
      expect(dialog.backgroundColor, Colors.red);
    });
  });

  group('showImageViewerPager', () {
    testWidgets('should have a PageView of images and invoke callbacks',
        (WidgetTester tester) async {
      List<ImageProvider> imageProviders = List.empty(growable: true);
      final context = await createTestBuildContext(tester);
      bool dismissed = false;
      int currentPage = -1;
      int pageOnDismissal = -1;

      await tester.runAsync(() async {
        const colors = [
          Colors.amber,
          Colors.red,
          Colors.green,
          Colors.blue,
          Colors.teal
        ];
        imageProviders =
            await Future.wait(colors.map((color) => createColorImage(color)));
      });

      final multiImageProvider = MultiImageProvider(imageProviders);

      final dialogFuture = showImageViewerPager(context, multiImageProvider,
          onPageChanged: (page) {
        currentPage = page;
      }, onViewerDismissed: (page) {
        dismissed = true;
        pageOnDismissal = page;
      });
      await tester.pumpAndSettle();

      // Create the Finders.
      final pageViewFinder = find.byKey(GlobalObjectKey(multiImageProvider));
      final closeButtonFinder = find.byIcon(Icons.close);

      // Check existence
      expect(pageViewFinder, findsOneWidget);
      expect(closeButtonFinder, findsOneWidget);

      // Swipe to second image
      await tester.drag(pageViewFinder, const Offset(-501.0, 0.0));
      await tester.pumpAndSettle();
      expect(currentPage, 1);

      // Swipe to third image
      await tester.drag(pageViewFinder, const Offset(-501.0, 0.0));
      await tester.pumpAndSettle();
      expect(currentPage, 2);

      // Dismiss the dialog
      await tester.tap(closeButtonFinder);

      await dialogFuture;

      expect(dismissed, true);
      expect(pageOnDismissal, 2);
    });

    testWidgets('should invoke callbacks when dismissed with a swipe',
        (WidgetTester tester) async {
      List<ImageProvider> imageProviders = List.empty(growable: true);
      final context = await createTestBuildContext(tester);
      bool dismissed = false;
      int pageOnDismissal = -1;

      await tester.runAsync(() async {
        const colors = [
          Colors.amber,
          Colors.red,
          Colors.green,
          Colors.blue,
          Colors.teal
        ];
        imageProviders =
            await Future.wait(colors.map((color) => createColorImage(color)));
      });

      final multiImageProvider = MultiImageProvider(imageProviders);

      final dialogFuture = showImageViewerPager(context, multiImageProvider,
          swipeDismissible: true, onViewerDismissed: (page) {
        dismissed = true;
        pageOnDismissal = page;
      });
      await tester.pumpAndSettle();

      // Create the Finders.
      final dismissibleFinder =
          find.byWidgetPredicate((widget) => widget is Dismissible);

      // Check existence
      expect(dismissibleFinder, findsOneWidget);

      // Swipe to dismiss
      await tester.drag(dismissibleFinder, const Offset(0, 501.0));
      await tester.pumpAndSettle();

      await dialogFuture;

      expect(dismissed, true);
      expect(pageOnDismissal, 0);
    });

    testWidgets('should respect the initialIndex', (WidgetTester tester) async {
      List<ImageProvider> imageProviders = List.empty(growable: true);
      final context = await createTestBuildContext(tester);
      bool dismissed = false;
      int pageOnDismissal = -1;

      await tester.runAsync(() async {
        const colors = [
          Colors.amber,
          Colors.red,
          Colors.green,
          Colors.blue,
          Colors.teal
        ];
        imageProviders =
            await Future.wait(colors.map((color) => createColorImage(color)));
      });

      final multiImageProvider =
          MultiImageProvider(imageProviders, initialIndex: 2);

      final dialogFuture = showImageViewerPager(context, multiImageProvider,
          onViewerDismissed: (page) {
        dismissed = true;
        pageOnDismissal = page;
      });
      await tester.pumpAndSettle();

      // Create the Finders.
      final closeButtonFinder = find.byIcon(Icons.close);

      // Check default closeButtonColor
      IconButton closeButton =
          tester.firstWidget(find.widgetWithIcon(IconButton, Icons.close));
      expect(closeButton.color, Colors.white);

      // Check default dialog backgroundColor
      Dialog dialog = tester
          .firstWidget(find.byWidgetPredicate((widget) => widget is Dialog));
      expect(dialog.backgroundColor, Colors.black);

      // Dismiss the dialog
      await tester.tap(closeButtonFinder);

      await dialogFuture;

      expect(dismissed, true);
      expect(pageOnDismissal, 2);
    });

    testWidgets('should respect the backgroundColor and closeButtonColor',
        (WidgetTester tester) async {
      List<ImageProvider> imageProviders = List.empty(growable: true);
      final context = await createTestBuildContext(tester);

      await tester.runAsync(() async {
        const colors = [Colors.amber];
        imageProviders =
            await Future.wait(colors.map((color) => createColorImage(color)));
      });

      final multiImageProvider = MultiImageProvider(imageProviders);

      showImageViewerPager(context, multiImageProvider,
          backgroundColor: Colors.red, closeButtonColor: Colors.green);
      await tester.pumpAndSettle();

      // Check default closeButtonColor
      IconButton closeButton =
          tester.firstWidget(find.widgetWithIcon(IconButton, Icons.close));
      expect(closeButton.color, Colors.green);

      // Check default dialog backgroundColor
      Dialog dialog = tester
          .firstWidget(find.byWidgetPredicate((widget) => widget is Dialog));
      expect(dialog.backgroundColor, Colors.red);
    });
  });
}
