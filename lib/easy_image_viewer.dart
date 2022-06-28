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
/// The optional [swipeDismissable] boolean defaults to false allows swipe-down-to-dismiss.
/// The [backgroundColor] defaults to black, but can be set to any other color.
/// The [closeButtonTooltip] text is displayed when the user long-presses on the
/// close button and is used for accessibility.
/// The [closeButtonColor] defaults to white, but can be set to any other color.
Future<Dialog?> showImageViewer(BuildContext context, ImageProvider imageProvider,
    {bool immersive = true,
    void Function()? onViewerDismissed,
    bool useSafeArea = false,
    bool swipeDismissable = false,
    Color backgroundColor = _defaultBackgroundColor,
    String closeButtonTooltip = _defaultCloseButtonTooltip,
    Color closeButtonColor = _defaultCloseButtonColor}) {
  return showImageViewerPager(context, SingleImageProvider(imageProvider),
      immersive: immersive,
      onViewerDismissed: onViewerDismissed != null ? (_) => onViewerDismissed() : null,
      useSafeArea: useSafeArea,
      swipeDismissable: swipeDismissable,
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
/// The optional [swipeDismissable] boolean defaults to false allows swipe-down-to-dismiss.
/// The [backgroundColor] defaults to black, but can be set to any other color.
/// The [closeButtonTooltip] text is displayed when the user long-presses on the
/// close button and is used for accessibility.
/// The [closeButtonColor] defaults to white, but can be set to any other color.
Future<Dialog?> showImageViewerPager(BuildContext context, EasyImageProvider imageProvider,
    {bool immersive = true,
    void Function(int)? onPageChanged,
    void Function(int)? onViewerDismissed,
    bool useSafeArea = false,
    bool swipeDismissable = false,
    Color backgroundColor = _defaultBackgroundColor,
    String closeButtonTooltip = _defaultCloseButtonTooltip,
    Color closeButtonColor = _defaultCloseButtonColor}) {
  if (immersive) {
    // Hide top and bottom bars
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  return showDialog<Dialog>(
      context: context,
      useSafeArea: useSafeArea,
      builder: (context) {
        print("---build showDialog");
        return EasyImageViewerDismissableDialog(imageProvider, immersive: immersive, onPageChanged: onPageChanged, onViewerDismissed: onViewerDismissed, useSafeArea: useSafeArea, swipeDismissable: swipeDismissable, backgroundColor: backgroundColor, closeButtonColor: closeButtonColor, closeButtonTooltip: closeButtonTooltip);
      });
}

class EasyImageViewerDismissableDialog extends StatefulWidget {
  final EasyImageProvider imageProvider;
  // final PageController pageController;
  final bool immersive;
  final void Function(int)? onPageChanged;
  final void Function(int)? onViewerDismissed;
  final bool useSafeArea;
  final bool swipeDismissable;
  final Color backgroundColor;
  final String closeButtonTooltip;
  final Color closeButtonColor;
  void Function()? internalPageChangeListener;

  EasyImageViewerDismissableDialog(this.imageProvider, {Key? key, bool this.immersive = true,
    void Function(int)? this.onPageChanged,
    void Function(int)? this.onViewerDismissed,
    bool this.useSafeArea = false,
    bool this.swipeDismissable = false,
    Color this.backgroundColor = _defaultBackgroundColor,
    String this.closeButtonTooltip = _defaultCloseButtonTooltip,
    Color this.closeButtonColor = _defaultCloseButtonColor}) : /*pageController = PageController(initialPage: imageProvider.initialIndex),*/ super(key: key) {
      // if (onPageChanged != null) {
      //   internalPageChangeListener = () {
      //     onPageChanged!(pageController.page?.round() ?? 0);
      //   };
      //   pageController.addListener(internalPageChangeListener!);
      // }  
      print("---creating new widget");
    }

  @override
  State<EasyImageViewerDismissableDialog> createState() => _EasyImageViewerDismissableDialogState();
}

class _EasyImageViewerDismissableDialogState extends State<EasyImageViewerDismissableDialog> with AutomaticKeepAliveClientMixin {
  
  DismissDirection _dismissDirection = DismissDirection.down;
  bool _canDismiss = true;
  final PageController _pageController = PageController();

  _EasyImageViewerDismissableDialogState() : super() {
    print("---creating new state");
  }
  
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("--- state build ${_pageController.positions.length > 0 ? _pageController.page : -1}");
    final dialog = Dialog(
              backgroundColor: widget.backgroundColor,
              insetPadding: const EdgeInsets.all(0),
              child: Stack(clipBehavior: Clip.none, alignment: Alignment.center, children: <Widget>[
                EasyImageViewPager(easyImageProvider: widget.imageProvider, pageController: _pageController, onScaleChanged: (scale) {
                  setState(() {
                    print("setState. old $_dismissDirection");
                    _canDismiss = scale <= 1.0;
                    print("setState. new $_dismissDirection ${_pageController.page}");
                  });
                }),
                Positioned(
                    top: 5,
                    right: 5,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      color: widget.closeButtonColor,
                      tooltip: widget.closeButtonTooltip,
                      onPressed: () {
                        Navigator.of(context).pop();

                        if (widget.onViewerDismissed != null) {
                          widget.onViewerDismissed!(_pageController.page?.round() ?? 0);
                        }

                        if (widget.immersive) {
                          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                        }
                        if (widget.internalPageChangeListener != null) {
                          _pageController.removeListener(widget.internalPageChangeListener!);
                        }
                        _pageController.dispose();
                      },
                    ))
              ]));

          if (widget.swipeDismissable) {
            return Dismissible(
                direction: _dismissDirection,
                resizeDuration: null,
                confirmDismiss: (_) async {
                  if (_canDismiss) {
                    return true;
                  } else {
                    return false;
                  }
                },
                onDismissed: (_) {
                  Navigator.of(context).pop();
                },
                key: const Key('dismissable_easy_image_viewer_dialog'),
                child: dialog);
          } else {
            return dialog;
          }
  }
}
