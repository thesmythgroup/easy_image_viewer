library easy_image_viewer;

import 'package:flutter/material.dart';

import 'easy_image_provider.dart';
import 'easy_image_view.dart';

/// PageView for swiping through a list of images
class EasyImageViewPager extends StatefulWidget {
  
  final EasyImageProvider easyImageProvider;
  final PageController pageController;

  /// Create new instance, using the [easyImageProvider] to populate the [PageView],
  /// and the [pageController] to control the initial image index to display.
  const EasyImageViewPager({ Key? key, required this.easyImageProvider, required this.pageController }) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _EasyImageViewPagerState createState() => _EasyImageViewPagerState(pageController: pageController);
}

class _EasyImageViewPagerState extends State<EasyImageViewPager> {

  final PageController pageController;

  _EasyImageViewPagerState({ required this.pageController }) : super();

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      key: const Key('easy_image_view_page_view'),
      itemCount: widget.easyImageProvider.imageCount,
      controller: pageController,
      itemBuilder: (context, index) {
        final image = widget.easyImageProvider.imageBuilder(context, index);
        return EasyImageView(
          key: Key('easy_image_view_$index'),
          imageProvider: image
        );
      }, 
    );
  }
}