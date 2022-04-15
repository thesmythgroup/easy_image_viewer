import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'easy_image_provider.dart';
import 'easy_image_view.dart';

/// Custom ScrollBehavior that allows dragging with all pointers
/// including the normally excluded mouse
class MouseEnabledScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => PointerDeviceKind.values.toSet();
}

/// PageView for swiping through a list of images
class EasyImageViewPager extends StatefulWidget {
  final EasyImageProvider easyImageProvider;
  final PageController pageController;

  /// Create new instance, using the [easyImageProvider] to populate the [PageView],
  /// and the [pageController] to control the initial image index to display.
  const EasyImageViewPager(
      {Key? key, required this.easyImageProvider, required this.pageController})
      : super(key: key);

  @override
  _EasyImageViewPagerState createState() =>
      // ignore: no_logic_in_create_state
      _EasyImageViewPagerState(pageController: pageController);
}

class _EasyImageViewPagerState extends State<EasyImageViewPager> {
  final PageController pageController;
  bool _pagingEnabled = true;

  _EasyImageViewPagerState({required this.pageController}) : super();

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      physics: _pagingEnabled
          ? const PageScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      key: const Key('easy_image_view_page_view'),
      itemCount: widget.easyImageProvider.imageCount,
      controller: pageController,
      scrollBehavior: MouseEnabledScrollBehavior(),
      itemBuilder: (context, index) {
        final image = widget.easyImageProvider.imageBuilder(context, index);
        return EasyImageView(
          key: Key('easy_image_view_$index'),
          imageProvider: image,
          onScaleChanged: (scale) {
            setState(() {
              _pagingEnabled = scale <= 1.0;
            });
          },
        );
      },
    );
  }
}
