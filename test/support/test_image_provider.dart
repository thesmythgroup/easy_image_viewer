// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file (https://github.com/flutter/flutter/blob/master/LICENSE).

import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Taken directly from the Flutter source code
/// See https://github.com/flutter/flutter/blob/master/packages/flutter/test/widgets/image_test.dart#L2060
class TestImageProvider extends ImageProvider<Object> {
  TestImageProvider({ImageStreamCompleter? streamCompleter}) {
    _streamCompleter = streamCompleter
      ?? OneFrameImageStreamCompleter(_completer.future);
  }

  final Completer<ImageInfo> _completer = Completer<ImageInfo>();
  late ImageStreamCompleter _streamCompleter;
  late ImageConfiguration lastResolvedConfiguration;

  bool get loadCalled => _loadCallCount > 0;
  int get loadCallCount => _loadCallCount;
  int _loadCallCount = 0;

  @override
  Future<Object> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<TestImageProvider>(this);
  }

  @override
  void resolveStreamForKey(ImageConfiguration configuration, ImageStream stream, Object key, ImageErrorListener handleError) {
    lastResolvedConfiguration = configuration;
    super.resolveStreamForKey(configuration, stream, key, handleError);
  }

  @override
  // Remove once the minimum Flutter version is 3.16+
  // ignore: deprecated_member_use
  ImageStreamCompleter loadBuffer(Object key, DecoderBufferCallback decode) {
    _loadCallCount += 1;
    return _streamCompleter;
  }

  // Use once the minimum Flutter version is 3.16+
  // @override
  // ImageStreamCompleter loadImage(Object key, ImageDecoderCallback decode) {
  //   _loadCallCount += 1;
  //   return _streamCompleter;
  // }

  void complete(ui.Image image) {
    _completer.complete(ImageInfo(image: image));
  }

  void fail(Object exception, StackTrace? stackTrace) {
    _completer.completeError(exception, stackTrace);
  }

  @override
  String toString() => '${describeIdentity(this)}()';
}