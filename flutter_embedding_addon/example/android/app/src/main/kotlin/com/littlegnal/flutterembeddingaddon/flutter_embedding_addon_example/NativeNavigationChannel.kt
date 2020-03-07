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

package com.littlegnal.flutterembeddingaddon.flutter_embedding_addon_example

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class NativeNavigationChannel(
  messenger: BinaryMessenger,
  val pushRouteCallback: (routeName: String) -> Unit,
  val popCallback: () -> Unit
) {

  private val channel = MethodChannel(messenger, "custom_channels/native_navigation")

  init {
    channel.setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
      when (call.method) {
        "pushRouteNative" -> {
          pushRouteCallback(call.argument<String>("route_name") ?: "")
          result.success(true)
        }
        "popNative" -> {
          popCallback()
          result.success(true)
        }
        else -> {
          result.notImplemented()
        }
      }
    }
  }

  fun pushRoute(routeName: String) {
    channel.invokeMethod("pushRoute", mapOf("route_name" to routeName))
  }

  fun pushReplacementNamed(routeName: String) {
    channel.invokeMethod("pushReplacementNamed", mapOf("route_name" to routeName))
  }
}