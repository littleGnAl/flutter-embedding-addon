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

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class GlobalNavigator {
  GlobalNavigator._() {
    _init();
  }

  factory GlobalNavigator() {
    return _globalNavigator;
  }
  static final GlobalNavigator _globalNavigator = GlobalNavigator._();
  final GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey();

  MethodChannel _channel;

  void _init() {
    _channel = MethodChannel("custom_channels/native_navigation")
      ..setMethodCallHandler((call) {
        switch (call.method) {
          case "pushRoute":
            var routeName = (call.arguments as Map)["route_name"] as String;
            pushNamed(routeName);
            return Future.value(true);
          case "pushReplacementNamed":
            var routeName = (call.arguments as Map)["route_name"] as String;
            pushReplacementNamed(routeName);
            return Future.value(true);
          default:
            return Future.value(false);
        }
      });
  }

  Future<T> pushNamed<T extends Object>(
    String routeName, {
    Object arguments,
  }) {
    return globalNavigatorKey.currentState
        .pushNamed<T>(routeName, arguments: arguments);
  }

  bool pop<T extends Object>({T result}) {
    if (globalNavigatorKey.currentState.canPop()) {
      return globalNavigatorKey.currentState.pop<T>();
    }

    popNative();
    return true;
  }

  Future<T> pushRouteNative<T>(String routeName) {
    return _channel
        .invokeMethod<T>("pushRouteNative", {"route_name": routeName});
  }

  Future<T> popNative<T>() {
    return _channel.invokeMethod<T>("popNative");
  }

  Future<T> pushReplacementNamed<T extends Object, TO extends Object>(
    String routeName, {
    TO result,
    Object arguments,
  }) {
    return globalNavigatorKey.currentState.pushReplacementNamed<T, TO>(
        routeName,
        result: result,
        arguments: arguments);
  }
}
