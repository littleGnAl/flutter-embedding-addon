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

package com.littlegnal.flutterembeddingaddon

import android.content.Context
import io.flutter.Log
import io.flutter.embedding.engine.FlutterEngine

class AddonFlutterEngineManager private constructor() {

  private object Holder {
    val instance =
            AddonFlutterEngineManager()
  }

  companion object {

    private const val TAG = "FlutterEngineManager"

    @JvmStatic
    val instance: AddonFlutterEngineManager by lazy { Holder.instance }
  }

  /**
   * How many [FlutterEngine]s can be cached in the cache. That mean if you set it to `2`, the third
   * engine will not be cached, which will be destroyed after the [AddonFlutterActivity]/[AddonFlutterFragment]
   * close.
   */
  var cacheFlutterEngineThreshold = 2

  private val activeEngines = mutableListOf<String>()
  private val eventChannels = mutableListOf<Pair<String, AddonEngineEventChannel>>()

  fun getFlutterEngine(context: Context): FlutterEngine {
    val cachedEngineIds = AddonFlutterEngineCache.instance.getCachedEngineIds()
    val cachedEngineIdsSize = cachedEngineIds.size
    val activeEngineSize = activeEngines.size
    if (cachedEngineIds.isNotEmpty() && activeEngineSize < cachedEngineIdsSize) {
      val existEngineId = cachedEngineIds.first { key ->
        activeEngines.none { key == it }
      }

      var engine = AddonFlutterEngineCache.instance.get(existEngineId)
      if (engine == null) {
        Log.d(
                TAG,
          "The cached engine with exist engineId: $existEngineId had been recycled, create a new one"
        )
        engine = createFlutterEngine(context)
      }
      Log.d(TAG, "Active a cached engine: $engine, id: $existEngineId")
      activeEngines.add(existEngineId)
      return engine
    }

    val flutterEngine: FlutterEngine
    val cacheEngineKey: String
    if (cachedEngineIdsSize < cacheFlutterEngineThreshold) {
      flutterEngine = createFlutterEngine(context)

      cacheEngineKey = "cache_engine_${cachedEngineIdsSize + 1}"
      AddonFlutterEngineCache.instance.put(cacheEngineKey, flutterEngine)
    } else {
      flutterEngine = createFlutterEngine(context)
      cacheEngineKey = "new_engine_${activeEngineSize - cachedEngineIdsSize + 1}"
    }

    val eventChannel =
            AddonEngineEventChannel(
                    flutterEngine.dartExecutor
            ) { eventName, arguments ->
              Log.d(
                      TAG,
                      "NativeEventChannel eventName: $eventName, arguments: $arguments"
              )
              eventChannels.asSequence()
                      .filter { (key, _) -> key != cacheEngineKey }
                      .forEach { (_, eventChannel) ->
                        eventChannel.sendEvent(eventName, arguments)
                      }

              true
            }
    eventChannels.add(cacheEngineKey to eventChannel)

    Log.d(TAG, "An engine: $flutterEngine has been active with key: $cacheEngineKey")
    activeEngines.add(cacheEngineKey)

    return flutterEngine
  }

  private fun createFlutterEngine(context: Context): FlutterEngine {
    return FlutterEngine(context.applicationContext).apply {
      navigationChannel.setInitialRoute("/")
    }
  }

  /**
   * Return `true` if current [FlutterEngine] that attached to
   * [AddonFlutterActivity]/[AddonFlutterFragment] should destroy with host.
   */
  fun shouldDestroyEngineWithHost(): Boolean = activeEngines.size > cacheFlutterEngineThreshold

  /**
   * Inactive the [FlutterEngine] that attached to the topmost
   * [AddonFlutterActivity]/[AddonFlutterFragment].
   */
  fun inactiveEngine() {
    if (activeEngines.isNotEmpty()) {
      val cachedEngineIds = AddonFlutterEngineCache.instance.getCachedEngineIds()
      val key = activeEngines.last()
      val removeEventChannelIndex = eventChannels.indexOfLast { (k, _) ->
        !cachedEngineIds.contains(key) && k == key
      }
      if (removeEventChannelIndex != -1) {
        Log.d(TAG, "NativeEventChannel with key: $key has been removed")
        eventChannels.removeAt(removeEventChannelIndex)
      }
      activeEngines.removeAt(activeEngines.size - 1)
    }
  }
}