import 'package:easy_image_viewer/src/single_image_provider.dart';

import 'support/test_helper.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SingleImageProvider', () {
    testWidgets('should return the correct image per index',
        (WidgetTester tester) async {
      ImageProvider? redImageProvider;
      BuildContext context = await createTestBuildContext(tester);

      await tester.runAsync(() async {
        redImageProvider = await createColorImageProvider(Colors.red);
      });

      final provider = SingleImageProvider(redImageProvider!);

      expect(provider.imageCount, 1);
      expect(provider.initialIndex, 0);

      expect(provider.imageBuilder(context, 0), redImageProvider);
      expect(() => provider.imageBuilder(context, -1), throwsArgumentError);
      expect(() => provider.imageBuilder(context, 1), throwsArgumentError);
    });

    testWidgets('should return the correct image widget per index',
        (WidgetTester tester) async {
      ImageProvider? redImageProvider;
      BuildContext context = await createTestBuildContext(tester);

      await tester.runAsync(() async {
        redImageProvider = await createColorImageProvider(Colors.red);
      });

      final provider = SingleImageProvider(redImageProvider!);

      expect(provider.imageCount, 1);
      expect(provider.initialIndex, 0);

      final imageWidget = provider.imageWidgetBuilder(context, 0);
      expect(imageWidget is Image, true);
      expect((imageWidget as Image).image, redImageProvider);

      expect(() => provider.imageWidgetBuilder(context, -1), throwsArgumentError);
      expect(() => provider.imageWidgetBuilder(context, 1), throwsArgumentError);
    });

    testWidgets('should return the correct error widget per index',
        (WidgetTester tester) async {
      ImageProvider? redImageProvider;
      BuildContext context = await createTestBuildContext(tester);

      await tester.runAsync(() async {
        redImageProvider = await createColorImageProvider(Colors.red);
      });

      final provider = SingleImageProvider(redImageProvider!);

      final errorWidget = provider.errorWidgetBuilder(context, 0, 'error', null);
      expect(errorWidget is Center, true);

      await tester.pumpWidget(MediaQuery(
          data: const MediaQueryData(size: Size(600, 800)),
          child: Directionality(textDirection: TextDirection.ltr, child: errorWidget)));

      expect(find.text('🖼️💥🚫', skipOffstage: false), findsOneWidget);
    });
  });
}
