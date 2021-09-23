import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_helper.dart';

import 'package:easy_image_viewer/easy_image_view.dart';

void main() {

  group('EasyImageView', () {
    testWidgets('should have an image and a scale', (WidgetTester tester) async {
      ImageProvider? imageProvider;
      
      await tester.runAsync(() async {
        imageProvider = await createColorImage(Colors.green);
      });
      
      Widget testWidget = MediaQuery(
        data: const MediaQueryData(size: Size(600, 800)),
        child: EasyImageView(imageProvider: imageProvider!, minScale: 0.5, maxScale: 6.0)
      );

      await tester.pumpWidget(testWidget);

      // Create the Finders.
      final sizedBoxFinder = find.byKey(const Key('easy_image_sized_box'));
      final interactiveViewFinder = find.byKey(const Key('easy_image_interactive_viewer'));
      final imageFinder = find.image(imageProvider!);

      // Check existence
      expect(sizedBoxFinder, findsOneWidget);
      expect(interactiveViewFinder, findsOneWidget);
      expect(imageFinder, findsOneWidget);

      // Check properties
      SizedBox sizedBox = tester.firstWidget(sizedBoxFinder);
      expect(sizedBox.width, 600);
      expect(sizedBox.height, 800);
      InteractiveViewer interactiveViewer = tester.firstWidget(interactiveViewFinder);
      expect(interactiveViewer.minScale, 0.5);
      expect(interactiveViewer.maxScale, 6.0);
    });
  });
}
