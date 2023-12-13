// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file (https://github.com/flutter/flutter/blob/master/LICENSE).

import 'package:flutter/widgets.dart';

/// Taken directly from the Flutter source code
/// See https://github.com/flutter/flutter/blob/master/packages/flutter/test/widgets/image_test.dart#L2103
class TestImageStreamCompleter extends ImageStreamCompleter {
  TestImageStreamCompleter([this._currentImage]);

  ImageInfo? _currentImage;
  final Set<ImageStreamListener> listeners = <ImageStreamListener>{};

  @override
  void addListener(ImageStreamListener listener) {
    listeners.add(listener);
    if (_currentImage != null) {
      listener.onImage(_currentImage!.clone(), true);
    }
  }

  @override
  void removeListener(ImageStreamListener listener) {
    listeners.remove(listener);
  }

  void setData({
    ImageInfo? imageInfo,
    ImageChunkEvent? chunkEvent,
  }) {
    if (imageInfo != null) {
      _currentImage?.dispose();
      _currentImage = imageInfo;
    }
    final List<ImageStreamListener> localListeners = listeners.toList();
    for (final ImageStreamListener listener in localListeners) {
      if (imageInfo != null) {
        listener.onImage(imageInfo.clone(), false);
      }
      if (chunkEvent != null && listener.onChunk != null) {
        listener.onChunk!(chunkEvent);
      }
    }
  }

  void setError({
    required Object exception,
    StackTrace? stackTrace,
  }) {
    final List<ImageStreamListener> localListeners = listeners.toList();
    for (final ImageStreamListener listener in localListeners) {
      listener.onError?.call(exception, stackTrace);
    }
  }
}