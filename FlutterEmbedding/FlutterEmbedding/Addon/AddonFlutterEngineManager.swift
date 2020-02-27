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
import FlutterPluginRegistrant
import os.log

class AddonFlutterEngineManager {
  private static let TAG = "AddonFlutterEngineManager"
  
  static let shared = AddonFlutterEngineManager()
  
  /**
  * How many `FlutterEngine`s can be cached in the cache.
  */
  var cacheFlutterEngineThreshold = 2
  
  private var activeEngines = [String]()
  private var eventChannels = [(String, AddonEngineEventChannel)]()
  
  private init() { }
  
  func getFlutterEngine() -> FlutterEngine {
    let cachedEngineIds = AddonFlutterEngineCache.shared.getCachedEngineIds()
    let cachedEngineIdsSize = cachedEngineIds.count
    let activeEngineSize = activeEngines.count
    if (!cachedEngineIds.isEmpty && activeEngineSize < cachedEngineIdsSize) {
      let existEngineId = cachedEngineIds.first(where: { (key) -> Bool in
        return !activeEngines.contains {
          return $0 == key as String
        }
      })!
      
      var engine = AddonFlutterEngineCache.shared.get(engineId: existEngineId)
      if engine == nil {
        os_log("%@: The cached engine with exist engineId: %@ had been recycled, create a new one",
               AddonFlutterEngineManager.TAG,
               existEngineId)
        engine = createFlutterEngine(name: existEngineId)
      }
      os_log("%@: Active a cached engine: %@, id: %@",
             AddonFlutterEngineManager.TAG,
             engine!,
             existEngineId)
      activeEngines.append(existEngineId)
      
      return engine!
    }
    
    let flutterEngine: FlutterEngine
    let cacheEngineId: String
    if cachedEngineIdsSize < cacheFlutterEngineThreshold {
      cacheEngineId = "cache_engine_\(cachedEngineIdsSize + 1)"
      flutterEngine = createFlutterEngine(name: cacheEngineId)
      AddonFlutterEngineCache.shared.put(engineId: cacheEngineId, engine: flutterEngine)
    } else {
      cacheEngineId = "new_engine_\(activeEngineSize - cachedEngineIdsSize + 1)"
      flutterEngine = createFlutterEngine(name: cacheEngineId)
    }
    
    let eventChannel = AddonEngineEventChannel(
      messenger: flutterEngine.binaryMessenger,
      eventCallback: { [unowned self] (eventName, arguments) -> Bool in
        os_log("%@: NativeEventChannel eventName: %@, arguments: %@",
               AddonFlutterEngineManager.TAG,
               eventName,
               String(describing: arguments))
        self.eventChannels
          .filter { (key, _) in key != cacheEngineId }
          .forEach { (_, eventChannel: AddonEngineEventChannel) in
            eventChannel.sendEvent(eventName: eventName, arguments: arguments)
        }

        return true
    })
    eventChannels.append((cacheEngineId, eventChannel))
    
    os_log("%@: An engine: %@ has been active with key: %@",
           AddonFlutterEngineManager.TAG,
           flutterEngine,
           cacheEngineId)
    activeEngines.append(cacheEngineId)
    
    return flutterEngine
  }
  
  private func createFlutterEngine(name: String) -> FlutterEngine {
    let engine = FlutterEngine(name: name)
    engine.navigationChannel.invokeMethod("setInitialRoute", arguments:"/")
    engine.run()
    GeneratedPluginRegistrant.register(with: engine)
    return engine
  }
  
  func shouldDestroyEngineWithHost() -> Bool {
    return activeEngines.count > cacheFlutterEngineThreshold
  }
  
  /**
   * Inactive the `FlutterEngine` that attached to the topmost `UIViewController`
   */
  func inactiveEngine() {
    if !activeEngines.isEmpty {
      let cachedEngineIds = AddonFlutterEngineCache.shared.getCachedEngineIds()
      let key = activeEngines.last!
      let removeEventChannelIndex = eventChannels.lastIndex { (k, _) -> Bool in
        !cachedEngineIds.contains(key) && k == key
      } ?? -1
      if removeEventChannelIndex != -1 {
        os_log("%@: NativeEventChannel with key: %@ has been removed",
               AddonFlutterEngineManager.TAG,
               key)
        eventChannels.remove(at: removeEventChannelIndex)
      }
      os_log("%@: FlutterEngine with key: %@ has been inactived",
      AddonFlutterEngineManager.TAG,
      key)
      activeEngines.remove(at: activeEngines.count - 1)
    }
  }
}
