import 'package:flutter/services.dart';

typedef NavigationCallback = void Function(String routeName);

class NativeNavigationChannel {

  NativeNavigationChannel(this._navigationCallback) {
    _init();
  }

  final NavigationCallback _navigationCallback;

  MethodChannel _channel;
      
  void _init() {
    _channel = MethodChannel("custom_channels/native_navigation")
      ..setMethodCallHandler((call) {
        switch (call.method) {
          case "pushRoute":
            var routeName = (call.arguments as Map)["route_name"] as String;
            _navigationCallback(routeName);
            return Future.value(true);
          default:
            return Future.value(false);
        }

      });
  }

  Future<T> pushRouteNative<T>(String routeName) {
    return _channel.invokeMethod<T>("pushRouteNative", {"route_name": routeName});
  }

  Future<T> popNative<T>() {
    return _channel.invokeMethod<T>("popNative");
  }
}
