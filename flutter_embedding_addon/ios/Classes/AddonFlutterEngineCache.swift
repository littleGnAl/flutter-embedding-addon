// Copyright (C) 2020 littlegnal

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at

//     http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation
import Flutter

class AddonFlutterEngineCache {
  private let cachedEngines = NSCache<NSString, FlutterEngine>()
  private var cachedEngineIds = Set<String>()
  
  static let shared = AddonFlutterEngineCache()
  
  private init() { }
  
  /**
   * Returns `true` if a `FlutterEngine` in this cache is associated with the
   * given `engineId`.
   */
  func contains(engineId: String) -> Bool {
    return cachedEngines.object(forKey: NSString(string: engineId)) != nil
  }
  
  /**
   * Returns the `FlutterEngine` in this cache that is associated with the given
   * `engineId`, or `null` is no such `FlutterEngine` exists.
   *
   * **NOTE**: It's possible that return a  `FlutterEngine` with `nil` for an exist `engineId`, because it
   * is cached by `NSCache` underly.
   */
  func get(engineId: String) -> FlutterEngine? {
    return cachedEngines.object(forKey: NSString(string: engineId))
  }
  
  /**
   * Places the given `FlutterEngine` in this cache and associates it with
   * the given `engineId`.
   */
  func put(engineId: String, engine: FlutterEngine) {
    cachedEngineIds.insert(engineId)
    cachedEngines.setObject(engine, forKey: NSString(string: engineId))
  }
  
  /**
   * Removes any `FlutterEngine` that is currently in the cache that is identified by
   * the given `engineId`.
   */
  func remove(engineId: String) {
    cachedEngineIds.remove(engineId)
    cachedEngines.removeObject(forKey: NSString(string: engineId))
  }
  
  /**
   * Return all engine ids in the cache
   */
  func getCachedEngineIds() -> Set<String> {
    return cachedEngineIds
  }
  
}
