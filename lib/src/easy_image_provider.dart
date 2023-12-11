import 'package:flutter/material.dart';

/// Provider for images, their count and the initial index to display
abstract class EasyImageProvider {
  /// Index of the initial image to display
  int get initialIndex;

  /// Total count of images
  int get imageCount;

  /// Animation duration for the image transition (fade in after loading)
  Duration animationDuration = const Duration(milliseconds: 300);

  /// Animation curve for the image transition (fade in after loading)
  Curve animationCurve = Curves.easeOut;

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
          duration: animationDuration,  
          curve: animationCurve,
          child: child,
        );
      },
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        bool shouldShowLoading = loadingProgress != null;
        return IndexedStack(
          index: shouldShowLoading ? 1 : 0,
          alignment: Alignment.center,
          children: <Widget>[
            child,
            progressIndicatorWidgetBuilder(
              context,
              index,
              value: loadingProgress?.expectedTotalBytes != null
                  ? loadingProgress!.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : shouldShowLoading ? null : 0.0,
            ),
          ],
        );
      },
    );
  }

  /// Returns the progress indicator widget for the given [index].
  /// The default implementation returns a [CircularProgressIndicator].
  /// Override this method to customize the progress indicator.
  /// The [value] parameter is the progress value between 0.0 and 1.0.
  /// If [value] is null, the progress indicator is in indeterminate mode.
  /// The [index] parameter is the index of the image being loaded.
  /// The [context] parameter is the build context.
  Widget progressIndicatorWidgetBuilder(BuildContext context, int index, {double? value}) {
    return CircularProgressIndicator(
      value: value,
    );
  }
}
