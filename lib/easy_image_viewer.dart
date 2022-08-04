/// A library to easily display images in a full-screen dialog.
/// It supports pinch & zoom, and paging through multiple images.
library easy_image_viewer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/easy_image_provider.dart';
import 'src/easy_image_view_pager.dart';
import 'src/single_image_provider.dart';

export 'src/easy_image_provider.dart' show EasyImageProvider;
export 'src/single_image_provider.dart' show SingleImageProvider;
export 'src/multi_image_provider.dart' show MultiImageProvider;

export 'src/easy_image_view.dart' show EasyImageView;
export 'src/easy_image_view_pager.dart' show EasyImageViewPager;

// Defined here so we don't repeat ourselves
const _defaultBackgroundColor = Colors.black;
const _defaultCloseButtonColor = Colors.white;
const _defaultCloseButtonTooltip = 'Close';

/// Shows the given [imageProvider] in a full-screen [Dialog].
/// Setting [immersive] to false will prevent the top and bottom bars from being hidden.
/// The optional [onViewerDismissed] callback function is called when the dialog is closed.
/// The optional [useSafeArea] boolean defaults to false and is passed to [showDialog].
/// The [backgroundColor] defaults to black, but can be set to any other color.
/// The [closeButtonTooltip] text is displayed when the user long-presses on the
/// close button and is used for accessibility.
/// The [closeButtonColor] defaults to white, but can be set to any other color.
Future<Dialog?> showImageViewer(
    BuildContext context, ImageProvider imageProvider,
    {bool immersive = true,
    void Function()? onViewerDismissed,
    bool useSafeArea = false,
    Color backgroundColor = _defaultBackgroundColor,
    String closeButtonTooltip = _defaultCloseButtonTooltip,
    Color closeButtonColor = _defaultCloseButtonColor}) {
  return showImageViewerPager(context, SingleImageProvider(imageProvider),
      immersive: immersive,
      onViewerDismissed:
          onViewerDismissed != null ? (_) => onViewerDismissed() : null,
      useSafeArea: useSafeArea,
      backgroundColor: backgroundColor,
      closeButtonTooltip: closeButtonTooltip,
      closeButtonColor: closeButtonColor);
}

/// Shows the images provided by the [imageProvider] in a full-screen PageView [Dialog].
/// Setting [immersive] to false will prevent the top and bottom bars from being hidden.
/// The optional [onPageChanged] callback function is called with the index of
/// the image when the user has swiped to another image.
/// The optional [onViewerDismissed] callback function is called with the index of
/// the image that is displayed when the dialog is closed.
/// The optional [useSafeArea] boolean defaults to false and is passed to [showDialog].
/// The [backgroundColor] defaults to black, but can be set to any other color.
/// The [closeButtonTooltip] text is displayed when the user long-presses on the
/// close button and is used for accessibility.
/// The [closeButtonColor] defaults to white, but can be set to any other color.
Future<Dialog?> showImageViewerPager(
    BuildContext context, EasyImageProvider imageProvider,
    {bool immersive = true,
    void Function(int)? onPageChanged,
    void Function(int)? onViewerDismissed,
    bool useSafeArea = false,
    Color backgroundColor = _defaultBackgroundColor,
    String closeButtonTooltip = _defaultCloseButtonTooltip,
    Color closeButtonColor = _defaultCloseButtonColor}) {
  if (immersive) {
    // Hide top and bottom bars
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  void Function()? internalPageChangeListener;
  final pageController =
      PageController(initialPage: imageProvider.initialIndex);

  if (onPageChanged != null) {
    internalPageChangeListener = () {
      onPageChanged(pageController.page?.round() ?? 0);
    };
    pageController.addListener(internalPageChangeListener);
  }

  return showDialog<Dialog>(
      context: context,
      useSafeArea: useSafeArea,
      builder: (context) {
        return Dialog(
            backgroundColor: backgroundColor,
            insetPadding: const EdgeInsets.all(0),
            // We set the shape here to ensure no rounded corners allow any of the 
            // underlying view to show. We want the whole background to be covered.
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: <Widget>[
                  EasyImageViewPager(
                      easyImageProvider: imageProvider,
                      pageController: pageController),
                  Positioned(
                      top: 5,
                      right: 5,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        color: closeButtonColor,
                        tooltip: closeButtonTooltip,
                        onPressed: () {
                          Navigator.of(context).pop();

                          if (onViewerDismissed != null) {
                            onViewerDismissed(
                                pageController.page?.round() ?? 0);
                          }

                          if (immersive) {
                            SystemChrome.setEnabledSystemUIMode(
                                SystemUiMode.edgeToEdge);
                          }
                          if (internalPageChangeListener != null) {
                            pageController
                                .removeListener(internalPageChangeListener);
                          }
                          pageController.dispose();
                        },
                      ))
                ]));
      });
}
