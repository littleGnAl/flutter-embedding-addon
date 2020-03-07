import 'dart:async';

import 'package:flutter/services.dart';

class FlutterEmbeddingAddon {
  static const MethodChannel _channel =
      const MethodChannel('flutter_embedding_addon');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
