import 'package:flutter/material.dart';

import 'easy_image_provider.dart';

/// Convenience provider for a list of [ImageProvider]s
class MultiImageProvider extends EasyImageProvider {
  final List<ImageProvider> imageProviders;
  @override
  final int initialIndex;

  MultiImageProvider(this.imageProviders, {this.initialIndex = 0}) {
    if (initialIndex < 0 || initialIndex >= imageProviders.length) {
      throw ArgumentError.value(initialIndex, 'initialIndex',
          'The initialIndex value must be between 0 and ${imageProviders.length - 1}.');
    }

    if (imageProviders.isEmpty) {
      throw ArgumentError.value(initialIndex, 'imageProviders',
          'The imageProviders list must not be empty.');
    }
  }

  @override
  ImageProvider imageBuilder(BuildContext context, int index) {
    if (index < 0 || index >= imageProviders.length) {
      throw ArgumentError.value(initialIndex, 'index',
          'The index value must be between 0 and ${imageProviders.length - 1}.');
    }

    return imageProviders[index];
  }

  @override
  int get imageCount => imageProviders.length;
}
