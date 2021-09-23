library easy_image_viewer;

import 'package:flutter/material.dart';

/// A full-sized view that displays the given image, supporting pinch & zoom
class EasyImageView extends StatefulWidget {

  /// The image to display
  final ImageProvider imageProvider;
  /// Minimum scale factor
  final double minScale;
  /// Maximum scale factor
  final double maxScale;
  /// Create a new instance
  const EasyImageView({
    Key? key,
    required this.imageProvider,
    this.minScale = 1.0,
    this.maxScale = 5.0
  }) : super(key: key);

  @override
  _EasyImageViewState createState() => _EasyImageViewState();
}

class _EasyImageViewState extends State<EasyImageView> {
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: const Key('easy_image_sized_box'),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height, 
      child: InteractiveViewer(
        key: const Key('easy_image_interactive_viewer'),
        minScale: widget.minScale,
        maxScale: widget.maxScale,
        child: Image(image: widget.imageProvider)
      )
    );
  }
}