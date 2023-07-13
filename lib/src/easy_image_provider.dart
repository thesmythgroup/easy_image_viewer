import 'package:flutter/material.dart';

/// Provider for images, their count and the initial index to display
abstract class EasyImageProvider {
  /// Index of the initial image to display
  int get initialIndex;

  /// Total count of images
  int get imageCount;

  /// Returns the image for the given [index].
  ImageProvider imageBuilder(BuildContext context, int index);

  /// Returns the image widget for the given [index].
  Widget imageWidgetBuilder(BuildContext context, int index) {
    return Image(
      image: imageBuilder(context, index),
      frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) {
          return child;
        }
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: child,
        );
      },
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        return IndexedStack(
          index: loadingProgress == null ? 0 : 1,
          alignment: Alignment.center,
          children: <Widget>[
            child,
            CircularProgressIndicator(
              value: loadingProgress?.expectedTotalBytes != null
                  ? loadingProgress!.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ],
        );
      },
    );
  }
}
