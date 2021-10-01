import 'package:easy_image_viewer/src/multi_image_provider.dart';

import 'support/test_helper.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MultiImageProvider', () {
    test('should require a valid initialIndex', () async {
      final imageProviders = [
        await createColorImage(Colors.red),
        await createColorImage(Colors.green)
      ];

      expect(() => MultiImageProvider(imageProviders, initialIndex: -1),
          throwsArgumentError);
      expect(() => MultiImageProvider(imageProviders, initialIndex: 2),
          throwsArgumentError);

      final provider0 = MultiImageProvider(imageProviders, initialIndex: 0);
      final provider1 = MultiImageProvider(imageProviders, initialIndex: 1);

      expect(provider0.initialIndex, 0);
      expect(provider1.initialIndex, 1);
    });

    testWidgets('should return the correct image per index',
        (WidgetTester tester) async {
      ImageProvider? redImageProvider;
      ImageProvider? greenImageProvider;
      BuildContext context = await createTestBuildContext(tester);

      await tester.runAsync(() async {
        redImageProvider = await createColorImage(Colors.red);
        greenImageProvider = await createColorImage(Colors.green);
      });

      final imageProviders = [redImageProvider!, greenImageProvider!];
      final provider = MultiImageProvider(imageProviders, initialIndex: 0);

      expect(provider.imageCount, 2);

      expect(provider.imageBuilder(context, 0), redImageProvider);
      expect(provider.imageBuilder(context, 1), greenImageProvider);
      expect(() => provider.imageBuilder(context, -1), throwsArgumentError);
      expect(() => provider.imageBuilder(context, 2), throwsArgumentError);
    });

    test('should require a non-empty list of ImageProviders', () async {
      expect(() => MultiImageProvider([]), throwsArgumentError);
    });
  });
}
