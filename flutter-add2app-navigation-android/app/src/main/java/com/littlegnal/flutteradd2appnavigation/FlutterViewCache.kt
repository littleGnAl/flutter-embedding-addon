package com.littlegnal.flutteradd2appnavigation

import android.content.Context
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.FlutterEngineCache

object FlutterViewCache {

    var flutterView: FlutterView? = null
        private set

    fun init(context: Context) {
        flutterView = FlutterView(context, FlutterView.RenderMode.texture, FlutterView.TransparencyMode.transparent)
        val flutterEngine = FlutterEngineCache.getInstance().get("cache_engine")!!
        flutterView!!.attachToFlutterEngine(flutterEngine)
    }
}