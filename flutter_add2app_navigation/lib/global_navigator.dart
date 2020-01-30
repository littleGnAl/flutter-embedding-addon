import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_add2app_navigation/native_navigation_channel.dart';

class GlobalNavigator {
  GlobalNavigator._() {
    _nativeNavigationChannel = NativeNavigationChannel((routeName) {
      pushNamed(routeName, arguments: {"isPushNative": true});
    });
  }
  factory GlobalNavigator() {
    return _globalNavigator;
  }
  static final GlobalNavigator _globalNavigator = GlobalNavigator._();
  final GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey();
  NativeNavigationChannel _nativeNavigationChannel;

  Future<T> pushNamed<T extends Object>(
    String routeName, {
    bool isPushNative = false,
    Object arguments,
  }) {
    var result = globalNavigatorKey.currentState
        .pushNamed<T>(routeName, arguments: arguments);
    if (isPushNative) {
      pushRouteNative(routeName);
    }
    return result;
  }

  bool pop<T extends Object>({bool isPushNative = false, T result}) {
    if (globalNavigatorKey.currentState.canPop()) {
      if (isPushNative) {
        popNative();
      }
      var result = globalNavigatorKey.currentState.pop<T>();
      
      return result;
    }

    popNative();
    return true;
  }

  Future<T> pushRouteNative<T>(String routeName) {
    return _nativeNavigationChannel.pushRouteNative(routeName);
  }

  Future<T> popNative<T>() {
    return _nativeNavigationChannel.popNative();
  }
}
