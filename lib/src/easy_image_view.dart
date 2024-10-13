import 'package:flutter/material.dart';

/// A full-sized view that displays the given image, supporting pinch & zoom
class EasyImageView extends StatefulWidget {
  /// The image widget to display
  final Widget imageWidget;

  /// Minimum scale factor
  final double minScale;

  /// Maximum scale factor
  final double maxScale;

  /// Whether to allow double tap to zoom in and out
  final bool doubleTapZoomable;

  /// How much to zoom during double tap zoom in
  final double doubleTapZoomScale;

  /// Callback for when the scale has changed, only invoked at the end of
  /// an interaction.
  final void Function(double)? onScaleChanged;

  /// Create a new instance that accepts an [ImageProvider]
  EasyImageView({
    Key? key,
    required ImageProvider imageProvider,
    double minScale = 1.0,
    double maxScale = 5.0,
    bool doubleTapZoomable = false,
    double doubleTapZoomScale = 2.0,
    void Function(double)? onScaleChanged,
  }) : this.imageWidget(
          Image(image: imageProvider),
          key: key,
          minScale: minScale,
          maxScale: maxScale,
          doubleTapZoomable: doubleTapZoomable,
          doubleTapZoomScale: doubleTapZoomScale,
          onScaleChanged: onScaleChanged,
        );

  /// Create a new instance
  /// The optional [doubleTapZoomable] boolean defaults to false and allows double tap to zoom.
  const EasyImageView.imageWidget(
    this.imageWidget, {
    super.key,
    this.minScale = 1.0,
    this.maxScale = 5.0,
    this.doubleTapZoomable = false,
    this.doubleTapZoomScale = 2.0,
    this.onScaleChanged,
  }) : assert(doubleTapZoomScale > 1.0);

  @override
  State<EasyImageView> createState() => _EasyImageViewState();
}

class _EasyImageViewState extends State<EasyImageView>
    with SingleTickerProviderStateMixin {
  final TransformationController _transformationController =
      TransformationController();

  TapDownDetails _doubleTapDetails = TapDownDetails();
  late AnimationController _animationController;
  Animation<Matrix4>? _doubleTapAnimation;
  Size? _viewport;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewport = MediaQuery.of(context).size;
  }

  @override
  Widget build(BuildContext context) {
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
                  child: widget.imageWidget,
                )
              : widget.imageWidget,
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
    final viewport = _viewport;
    if (viewport == null) {
      return;
    }

    _doubleTapAnimation?.removeListener(_animationListener);
    _doubleTapAnimation?.removeStatusListener(_animationStatusListener);

    final scaleCur = _transformationController.value.getMaxScaleOnAxis();
    final scaleDest = widget.doubleTapZoomScale;
    if (scaleCur < scaleDest) {
      // we are not at a doubleTapZoomScale yet, zoom in all the way to it.
      final tap = _doubleTapDetails.localPosition;
      // center viewport where user tapped
      final dx = tap.dx * scaleDest - (viewport.width / 2.0);
      final dy = tap.dy * scaleDest - (viewport.height / 2.0);
      // ensure we don't go out of bound.
      // Furthest point we can translate to is one viewpoint less.
      final cdx = dx.clamp(0.0, viewport.width * (scaleDest - 1));
      final cdy = dy.clamp(0.0, viewport.height * (scaleDest - 1));

      final begin = _transformationController.value;
      final end = Matrix4.identity()
        ..translate(-cdx, -cdy)
        ..scale(scaleDest);

      _updateDoubleTapAnimation(begin, end);
      _animationController.forward(from: 0.0);
    } else {
      // we are zoomed in at doubleTapZoomScale or more, zoom all the way out
      final begin = Matrix4.identity();
      final end = _transformationController.value;

      _updateDoubleTapAnimation(begin, end);
      _animationController.reverse(from: 1.0);
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
