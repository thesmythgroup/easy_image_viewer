import 'package:flutter/material.dart';

/// A full-sized view that displays the given image, supporting pinch & zoom
class EasyImageView extends StatefulWidget {
  /// The image to display
  final ImageProvider imageProvider;

  /// Minimum scale factor
  final double minScale;

  /// Maximum scale factor
  final double maxScale;

  /// Callback for when the scale has changed, only invoked at the end of
  /// an interaction.
  final void Function(double)? onScaleChanged;

  /// Create a new instance
  const EasyImageView({
    Key? key,
    required this.imageProvider,
    this.minScale = 1.0,
    this.maxScale = 5.0,
    this.onScaleChanged,
  }) : super(key: key);

  @override
  _EasyImageViewState createState() => _EasyImageViewState();
}

class _EasyImageViewState extends State<EasyImageView> {
  final TransformationController _transformationController = TransformationController();

  TapDownDetails _doubleTapDetails=TapDownDetails();

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
        key: const Key('easy_image_sized_box'),
        child: 
             InteractiveViewer(
          key: const Key('easy_image_interactive_viewer'),
          transformationController: _transformationController,
          minScale: widget.minScale,
          maxScale: widget.maxScale,
          child: GestureDetector(
              onDoubleTapDown: _handleDoubleTapDown,
              onDoubleTap: _handleDoubleTap,
            child: Image(image: widget.imageProvider)
          ),
          onInteractionEnd: (scaleEndDetails) {
            double scale = _transformationController.value.getMaxScaleOnAxis();
             
            if (widget.onScaleChanged != null) {
              widget.onScaleChanged!(scale);
            }
          },
        ));
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails.localPosition;
     
      _transformationController.value = Matrix4.identity()
      // Fox a 2x zoom
      ..translate(-position.dx, -position.dy)
      ..scale(2.0);
      // For a 3x zoom
        // ..translate(-position.dx * 2, -position.dy * 2)
        // ..scale(3.0);
    }
  }
}
