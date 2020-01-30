/*
 * Copyright (C) 2020 littlegnal
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef EventListener = void Function(String eventName, dynamic arguments);

class EventDispatcher {
  EventDispatcher._() {
    _eventChannel = MethodChannel("custom_channels/native_event")
      ..setMethodCallHandler((call) {
        _eventListeners.forEach((e) {
          e(call.method, call.arguments);
        });
        return Future.value(true);
      });
  }

  factory EventDispatcher() {
    return _eventDispatcher;
  }

  static final EventDispatcher _eventDispatcher = EventDispatcher._();

  MethodChannel _eventChannel;

  final List<EventListener> _eventListeners = List();

  VoidCallback addEventListener(EventListener eventListener) {
    _eventListeners.add(eventListener);

    return () {
      _eventListeners.remove(eventListener);
    };
  }

  void removeEventListener(EventListener eventListener) {
    _eventListeners.remove(eventListener);
  }

  Future<T> sendEvent<T>(String eventName, dynamic arguments) {
    return _eventChannel.invokeMethod<T>(eventName, arguments);
  }
}
