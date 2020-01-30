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

package com.littlegnal.flutterembedding.addon

import io.flutter.embedding.engine.FlutterEngine
import java.lang.ref.SoftReference

class AddonFlutterEngineCache private constructor() {

  private object Holder {
    val instance =
      AddonFlutterEngineCache()
  }

  companion object {

    @JvmStatic
    val instance: AddonFlutterEngineCache by lazy { Holder.instance }
  }

  private val cachedEngines: MutableMap<String, SoftReference<FlutterEngine>> = mutableMapOf()

  /**
   * Returns `true` if a [FlutterEngine] in this cache is associated with the
   * given `engineId`.
   */
  fun contains(engineId: String): Boolean = cachedEngines.containsKey(engineId)

  /**
   * Returns the [FlutterEngine] in this cache that is associated with the given
   * `engineId`, or `null` is no such [FlutterEngine] exists.
   *
   * **NOTE**: It's possible that return a `null` [FlutterEngine] for an exist `engineId`, because it
   * is cached by [SoftReference] underly.
   */
  fun get(engineId: String): FlutterEngine? = cachedEngines[engineId]?.get()

  /**
   * Places the given [FlutterEngine] with [SoftReference] in this cache and associates it with
   * the given `engineId`.
   */
  fun put(engineId: String, engine: FlutterEngine) {
    cachedEngines[engineId] = SoftReference(engine)
  }

  /**
   * Removes any [FlutterEngine] that is currently in the cache that is identified by
   * the given `engineId`.
   */
  fun remove(engineId: String) = cachedEngines.remove(engineId)

  /**
   * Return all engine ids in the cache
   */
  fun getCachedEngineIds(): Set<String> = cachedEngines.keys
}