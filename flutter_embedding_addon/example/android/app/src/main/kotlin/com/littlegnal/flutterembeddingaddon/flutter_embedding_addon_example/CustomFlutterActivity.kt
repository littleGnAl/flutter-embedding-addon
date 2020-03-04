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

import android.content.Context
import android.content.Intent
import com.littlegnal.flutterembeddingaddon.AddonFlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class CustomFlutterActivity : AddonFlutterActivity() {

  companion object {
    private const val EXTRA_CUSTOM_INITIAL_ROUTE = "custom_initial_route"

    fun openCustomNewFlutterActivity(context: Context, initialRoute: String? = null) {
      val intent = Intent(context, CustomFlutterActivity::class.java)
      if (initialRoute != null) {
        intent.putExtra(EXTRA_CUSTOM_INITIAL_ROUTE, initialRoute)
      }
      context.startActivity(intent)
    }
  }

  private lateinit var navigationChannel: NativeNavigationChannel

  private var isPushInitialRoute = false

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)

    navigationChannel =
      NativeNavigationChannel(flutterEngine.dartExecutor, pushRouteCallback = {
        openCustomNewFlutterActivity(this, it)
      }, popCallback = {
        finish()
      })
  }

  override fun onFlutterUiDisplayed() {
    super.onFlutterUiDisplayed()

    if (!isPushInitialRoute) {
      val route = intent.getStringExtra(EXTRA_CUSTOM_INITIAL_ROUTE) ?: "/"
      navigationChannel.pushReplacementNamed(route)

      isPushInitialRoute = true
    }
  }
}