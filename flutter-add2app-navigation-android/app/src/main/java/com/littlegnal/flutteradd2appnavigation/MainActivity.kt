package com.littlegnal.flutteradd2appnavigation

import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.AppCompatButton
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngineCache

class MainActivity : AppCompatActivity() {

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_main)

//    val flutterEngine = FlutterEngineCache.getInstance().get("cache_engine")!!
//    val navigationChannel = NativeNavigationChannel(flutterEngine.dartExecutor, pushRouteCallback = {
//      Log.d("MainActivity", "push a new Activity with route: $it")
//      Handler().postDelayed({
//        startActivity(FlutterActivity.withCachedEngine("cache_engine").build(this))
//      }, 1000)
//    }, popCallback = {
//      onBackPressed()
//    })

    findViewById<AppCompatButton>(R.id.btnNormalFlutterNavigationFlow).setOnClickListener {
      startActivity(FlutterActivity.withCachedEngine("cache_engine").build(this))
    }

    findViewById<AppCompatButton>(R.id.btnFlutterToNativeFlow).setOnClickListener {

      startActivity(Intent(this, Add2AppActivity::class.java))


    }

  }
}
