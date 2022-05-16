import 'package:easy_image_viewer/src/easy_image_view.dart';
import 'package:easy_image_viewer/src/multi_image_provider.dart';
import 'package:easy_image_viewer/src/easy_image_view_pager.dart';

import 'support/test_helper.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EasyImageViewerPager', () {
    testWidgets('should have a PageView of images',
        (WidgetTester tester) async {
      List<ImageProvider> imageProviders = List.empty(growable: true);

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
      final pageController =
          PageController(initialPage: multiImageProvider.initialIndex);

      Widget testWidget = MediaQuery(
          data: const MediaQueryData(size: Size(600, 800)),
          child: Directionality(
              textDirection: TextDirection.ltr,
              child: EasyImageViewPager(
                  easyImageProvider: multiImageProvider,
                  pageController: pageController)));

      await tester.pumpWidget(testWidget);

      // Create the Finders.
      final pageViewFinder = find.byKey(GlobalObjectKey(multiImageProvider));
      final easyImageViewFinder = find.byKey(const Key('easy_image_view_0'));
      final imageFinder = find.image(imageProviders.first);

      // Check existence
      expect(pageViewFinder, findsOneWidget);
      expect(easyImageViewFinder, findsOneWidget);
      expect(imageFinder, findsOneWidget);

      // Check properties
      PageView pageView = tester.firstWidget(pageViewFinder);
      expect(pageView.controller, pageController);
      EasyImageView easyImageView = tester.firstWidget(easyImageViewFinder);
      expect(easyImageView.imageProvider, imageProviders.first);
    });
  });
}
