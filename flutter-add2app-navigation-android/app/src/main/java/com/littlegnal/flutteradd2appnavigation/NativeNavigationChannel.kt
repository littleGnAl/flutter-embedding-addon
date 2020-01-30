package com.littlegnal.flutteradd2appnavigation

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
}