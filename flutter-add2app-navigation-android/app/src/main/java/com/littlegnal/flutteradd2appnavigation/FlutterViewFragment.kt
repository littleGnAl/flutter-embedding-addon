package com.littlegnal.flutteradd2appnavigation

import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.fragment.app.Fragment
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.platform.PlatformPlugin

class FlutterViewFragment : Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        (FlutterViewCache.flutterView?.parent as? FrameLayout)?.removeView(FlutterViewCache.flutterView)
        val frameLayout = FrameLayout(inflater.context)
//        val flutterEngine = FlutterEngineCache.getInstance().get("cache_engine")!!
//        val platformPlugin = PlatformPlugin(activity, flutterEngine.platformChannel)
//        val flutterView = FlutterView(
//            context!!,
//            FlutterView.RenderMode.texture,
//            FlutterView.TransparencyMode.transparent
//        )
//
//        flutterView.attachToFlutterEngine(flutterEngine)

//        frameLayout.addView(FlutterViewCache.flutterView)
        FlutterViewCache.flutterView?.attachToFlutterEngine(FlutterEngineCache.getInstance().get("cache_engine")!!)

        frameLayout.addView(FlutterViewCache.flutterView)

        return frameLayout
    }

//    override fun onDestroyView() {
//        (view as? FrameLayout)?.removeView(FlutterViewCache.flutterView)
//        super.onDestroyView()
//    }

//    override fun onResume() {
//        super.onResume()
//        Log.e("FlutterViewFragment", "FlutterViewCache.flutterView parent : ${FlutterViewCache.flutterView?.parent}")
//        (FlutterViewCache.flutterView?.parent as? FrameLayout)?.removeView(FlutterViewCache.flutterView)
//        (view as? FrameLayout)?.addView(FlutterViewCache.flutterView)
//    }

//    override fun onPause() {
//        super.onPause()
//        val p = (view as? FrameLayout)
//        Log.e("FlutterViewFragment", "p : $p")
//        p?.removeView(FlutterViewCache.flutterView)
//    }
}