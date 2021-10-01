import 'package:flutter/material.dart';

/// Provider for images, their count and the initial index to display
abstract class EasyImageProvider {
  /// Index of the initial image to display
  int get initialIndex;

  /// Total count of images
  int get imageCount;

  /// Returns the image for the given [index].
  ImageProvider imageBuilder(BuildContext context, int index);
}
