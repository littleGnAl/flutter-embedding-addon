// Copyright (C) 2020 littlegnal

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at

//     http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation
import Flutter

class NativeNavigationChannel {
  
  private let pushRouteCallback: (_ routeName: String) -> Void
  private let popCallback: () -> Void
  private let channel: FlutterMethodChannel
  
  init(
    messenger: FlutterBinaryMessenger,
    pushRouteCallback: @escaping (_ routeName: String) -> Void,
    popCallback: @escaping () -> Void
  ) {
    self.pushRouteCallback = pushRouteCallback
    self.popCallback = popCallback
    channel = FlutterMethodChannel(
      name: "custom_channels/native_navigation",
      binaryMessenger: messenger)
    channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      switch call.method {
      case "pushRouteNative":
        let map = call.arguments as? [String: Any]
        let routeName = map?["route_name"] as? String ?? ""
        pushRouteCallback(routeName)
        result(true)
      case "popNative":
        popCallback()
        result(true)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
  
  func pushRoute(routeName: String) {
    channel.invokeMethod("pushRoute", arguments: ["route_name": routeName])
  }
  
  func pushReplacementNamed(routeName: String) {
    channel.invokeMethod("pushReplacementNamed", arguments: ["route_name": routeName])
  }
}
