import 'package:flutter/material.dart';

/// A full-sized view that displays the given image, supporting pinch & zoom
class EasyImageView extends StatefulWidget {
  /// The image to display
  final ImageProvider imageProvider;

  /// Minimum scale factor
  final double minScale;

  /// Maximum scale factor
  final double maxScale;

  /// Whether to allow double tap to zoom in and out
  final bool doubleTapZoomable;

  /// Callback for when the scale has changed, only invoked at the end of
  /// an interaction.
  final void Function(double)? onScaleChanged;

  /// Create a new instance
  /// The optional [doubleTapZoomable] boolean defaults to false and allows double tap to zoom.
  const EasyImageView({
    Key? key,
    required this.imageProvider,
    this.minScale = 1.0,
    this.maxScale = 5.0,
    this.doubleTapZoomable = false,
    this.onScaleChanged,
  }) : super(key: key);

  @override
  _EasyImageViewState createState() => _EasyImageViewState();
}

class _EasyImageViewState extends State<EasyImageView>
    with SingleTickerProviderStateMixin {
  final TransformationController _transformationController =
      TransformationController();

  TapDownDetails _doubleTapDetails = TapDownDetails();
  late AnimationController _animationController;
  Animation<Matrix4>? _doubleTapAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final image = Image(image: widget.imageProvider);
    return SizedBox.expand(
        key: const Key('easy_image_sized_box'),
        child: InteractiveViewer(
          key: const Key('easy_image_interactive_viewer'),
          transformationController: _transformationController,
          minScale: widget.minScale,
          maxScale: widget.maxScale,
          child: widget.doubleTapZoomable
              ? GestureDetector(
                  onDoubleTapDown: _handleDoubleTapDown,
                  onDoubleTap: _handleDoubleTap,
                  child: image)
              : image,
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
    _doubleTapAnimation?.removeListener(_animationListener);
    _doubleTapAnimation?.removeStatusListener(_animationStatusListener);

    double scale = _transformationController.value.getMaxScaleOnAxis();

    if (scale < 2.0) {
      // If we are not at a 2x scale yet, zoom in all the way to 2x.
      final position = _doubleTapDetails.localPosition;
      final begin = _transformationController.value;
      final end = Matrix4.identity()
        ..translate(-position.dx, -position.dy)
        ..scale(2.0);

      _updateDoubleTapAnimation(begin, end);
      _animationController.forward(from: 0.0);
    } else {
      // If we are zoomed in at 2x or more, zoom all the way out
      final begin = Matrix4.identity();
      final end = _transformationController.value;

      _updateDoubleTapAnimation(begin, end);

      _animationController.reverse(from: scale - 1.0);
    }
  }

  void _updateDoubleTapAnimation(Matrix4 begin, Matrix4 end) {
    _doubleTapAnimation = Matrix4Tween(begin: begin, end: end).animate(
        CurveTween(curve: Curves.easeInOut).animate(_animationController));
    _doubleTapAnimation?.addListener(_animationListener);
    _doubleTapAnimation?.addStatusListener(_animationStatusListener);
  }

  void _animationListener() {
    _transformationController.value =
        _doubleTapAnimation?.value ?? Matrix4.identity();
  }

  void _animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed ||
        status == AnimationStatus.dismissed) {
      double scale = _transformationController.value.getMaxScaleOnAxis();

      if (widget.onScaleChanged != null) {
        widget.onScaleChanged!(scale);
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
