import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Helper method to create a sample image
Future<ImageProvider> createColorImage(Color color,
    {double scale = 1.0, int width = 500, int height = 500}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  canvas.scale(scale, scale);

  final paint = Paint()
    ..style = PaintingStyle.fill
    ..color = color;

  canvas.drawRect(
      Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), paint);
  final ui.Image image = await recorder.endRecording().toImage(width, height);
  final imageData = await image.toByteData(format: ui.ImageByteFormat.png);
  return MemoryImage(imageData!.buffer.asUint8List());
}

/// Helper method to create a BuildContext
Future<BuildContext> createTestBuildContext(WidgetTester tester) async {
  await tester.pumpWidget(MaterialApp(home: Material(child: Container())));
  final BuildContext context = tester.element(find.byType(Container));

  return context;
}
