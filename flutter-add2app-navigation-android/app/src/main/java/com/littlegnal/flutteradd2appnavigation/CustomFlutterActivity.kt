package com.littlegnal.flutteradd2appnavigation

import android.os.Bundle
import android.os.Handler
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentManager
import io.flutter.embedding.android.FlutterFragment
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.android.NewFlutterFragment
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.renderer.FlutterUiDisplayListener

class CustomFlutterActivity : AppCompatActivity(), FlutterUiDisplayListener {

    // Define a tag String to represent the FlutterFragment within this
// Activity's FragmentManager. This value can be whatever you'd like.
    private val TAG_FLUTTER_FRAGMENT = "flutter_fragment"

    // Declare a local variable to reference the FlutterFragment so that you
// can forward calls to it later.
    private var flutterFragment: FlutterFragment? = null

    private var isNeedPop = false

    private lateinit var nativeNavigationChannel: NativeNavigationChannel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContentView(R.layout.activity_add2app)

        val flutterEngine = FlutterEngineCache.getInstance().get("cache_engine")!!
        nativeNavigationChannel = NativeNavigationChannel(flutterEngine.dartExecutor, pushRouteCallback = {

        }, popCallback = {
            isNeedPop = true
        })

        val fragmentManager: FragmentManager = supportFragmentManager

        // Attempt to find an existing FlutterFragment, in case this is not the
        // first time that onCreate() was run.
        // Attempt to find an existing FlutterFragment, in case this is not the
// first time that onCreate() was run.
        flutterFragment = fragmentManager
            .findFragmentByTag(TAG_FLUTTER_FRAGMENT) as? FlutterFragment

        // Create and attach a FlutterFragment if one does not exist.
        // Create and attach a FlutterFragment if one does not exist.
        if (flutterFragment == null) {
            flutterFragment = FlutterFragment
                .withCachedEngine("cache_engine")
                .transparencyMode(FlutterView.TransparencyMode.transparent)
                .renderMode(FlutterView.RenderMode.texture)
                .build()
            fragmentManager
                .beginTransaction()
                .add(
                    R.id.flAdd2AppLayout,
                    flutterFragment as Fragment,
                    TAG_FLUTTER_FRAGMENT
                )
                .commit()
        }
    }

    override fun onFlutterUiNoLongerDisplayed() {
        if (isNeedPop) {
            finish()
            isNeedPop = false
        }
    }

    override fun onFlutterUiDisplayed() {

    }
}