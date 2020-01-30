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

package com.littlegnal.flutterembedding

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentManager
import com.littlegnal.flutterembedding.addon.AddonFlutterFragment
import io.flutter.embedding.android.DrawableSplashScreen
import io.flutter.embedding.android.FlutterEngineConfigurator
import io.flutter.embedding.android.SplashScreen
import io.flutter.embedding.android.SplashScreenProvider
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.renderer.FlutterUiDisplayListener

class CustomFlutterFragmentActivity : AppCompatActivity(), FlutterEngineConfigurator,
  SplashScreenProvider, FlutterUiDisplayListener {

  companion object {
    private const val TAG_FLUTTER_FRAGMENT = "flutter_fragment"
  }

  private lateinit var navigationChannel: NativeNavigationChannel

  private var flutterFragment: AddonFlutterFragment? = null

  private var isPushInitialRoute = false

  override fun provideSplashScreen(): SplashScreen? =
    DrawableSplashScreen(resources.getDrawable(R.drawable.launch_background, null))

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)

    setContentView(R.layout.activity_custom_flutter_fragment)

    val fragmentManager: FragmentManager = supportFragmentManager

    flutterFragment = fragmentManager
      .findFragmentByTag(TAG_FLUTTER_FRAGMENT) as? AddonFlutterFragment

    if (flutterFragment == null) {
      flutterFragment =
        AddonFlutterFragment()
      fragmentManager
        .beginTransaction()
        .add(
          R.id.flFlutterFragment,
          flutterFragment as Fragment,
          TAG_FLUTTER_FRAGMENT
        )
        .commit()
    }
  }

  override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {}

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    navigationChannel = NativeNavigationChannel(flutterEngine.dartExecutor, pushRouteCallback = {
      CustomFlutterActivity.openCustomNewFlutterActivity(this, it)
    }, popCallback = {
      finish()
    })
  }

  override fun onFlutterUiNoLongerDisplayed() {}

  override fun onFlutterUiDisplayed() {
    if (!isPushInitialRoute) {
      navigationChannel.pushReplacementNamed("/first_page")

      isPushInitialRoute = true
    }
  }

  override fun onPostResume() {
    super.onPostResume()
    flutterFragment?.onPostResume()
  }

  override fun onNewIntent(intent: Intent) {
    flutterFragment?.onNewIntent(intent)
    super.onNewIntent(intent)
  }

  override fun onBackPressed() {
    flutterFragment?.onBackPressed()
  }

  override fun onRequestPermissionsResult(
    requestCode: Int,
    permissions: Array<String?>,
    grantResults: IntArray
  ) {
    flutterFragment?.onRequestPermissionsResult(
      requestCode,
      permissions,
      grantResults
    )
  }

  override fun onUserLeaveHint() {
    flutterFragment?.onUserLeaveHint()
  }

  override fun onTrimMemory(level: Int) {
    super.onTrimMemory(level)
    flutterFragment?.onTrimMemory(level)
  }

}