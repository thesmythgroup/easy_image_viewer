import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_helper.dart';

void main() {

  group('showImageViewer', () {
    testWidgets('should have a PageView of images and invoke dismissal callback', (WidgetTester tester) async {

      ImageProvider? redImageProvider;
      BuildContext context = await createTestBuildContext(tester);
      bool dismissed = false;

      await tester.runAsync(() async {
        redImageProvider = await createColorImage(Colors.red);
      });
      
      final dialogFuture = showImageViewer(context, redImageProvider!, onViewerDismissed: () {
        dismissed = true;
      });
      await tester.pumpAndSettle();

      // Create the Finders.
      final pageViewFinder = find.byKey(const Key('easy_image_view_page_view'));
      final closeButtonFinder = find.byIcon(Icons.close);

      // Check existence
      expect(pageViewFinder, findsOneWidget);
      expect(closeButtonFinder, findsOneWidget);

      // Dismiss the dialog
      await tester.tap(closeButtonFinder);

      await dialogFuture;

      expect(dismissed, true);
    });
  });

  group('showImageViewerPager', () {
    testWidgets('should have a PageView of images and invoke callbacks', (WidgetTester tester) async {

      List<ImageProvider> imageProviders = List.empty(growable: true);
      final context = await createTestBuildContext(tester);
      bool dismissed = false;
      int currentPage = -1;
      int pageOnDismissal = -1;
      
      await tester.runAsync(() async {
        const colors = [Colors.amber, Colors.red, Colors.green, Colors.blue, Colors.teal];
        imageProviders = await Future.wait(colors.map((color) => createColorImage(color)));
      });

      final multiImageProvider = MultiImageProvider(imageProviders);
            
      final dialogFuture = showImageViewerPager(context, multiImageProvider, onPageChanged: (page) {
        currentPage = page;
      }, onViewerDismissed: (page) {
        dismissed = true;
        pageOnDismissal = page;
      });
      await tester.pumpAndSettle();

      // Create the Finders.
      final pageViewFinder = find.byKey(const Key('easy_image_view_page_view'));
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

    testWidgets('should respect the initialIndex', (WidgetTester tester) async {

      List<ImageProvider> imageProviders = List.empty(growable: true);
      final context = await createTestBuildContext(tester);
      bool dismissed = false;
      int pageOnDismissal = -1;
      
      await tester.runAsync(() async {
        const colors = [Colors.amber, Colors.red, Colors.green, Colors.blue, Colors.teal];
        imageProviders = await Future.wait(colors.map((color) => createColorImage(color)));
      });

      final multiImageProvider = MultiImageProvider(imageProviders, initialIndex: 2);
            
      final dialogFuture = showImageViewerPager(context, multiImageProvider, onViewerDismissed: (page) {
        dismissed = true;
        pageOnDismissal = page;
      });
      await tester.pumpAndSettle();

      // Create the Finders.
      final closeButtonFinder = find.byIcon(Icons.close);

      // Dismiss the dialog
      await tester.tap(closeButtonFinder);

      await dialogFuture;

      expect(dismissed, true);
      expect(pageOnDismissal, 2);
    });
  });
}

