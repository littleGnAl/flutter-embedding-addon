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

open class AddonFlutterViewController: UIViewController {
  
  private var flutterViewDidRenderCallback: (() -> Void)?
  
  override open func viewDidLoad() {
    super.viewDidLoad()
    let splashViewController = providerSplashViewControler()
    if (splashViewController != nil) {
      splashViewController!.willMove(toParent: self)
      addChild(splashViewController!)
      splashViewController!.view.frame = self.view.bounds
      view.addSubview(splashViewController!.view)
      splashViewController!.didMove(toParent: self)
    }
    
    let engine = AddonFlutterEngineManager.shared.getFlutterEngine()
    configureFlutterEngine(engine: engine)
    
    let flutterViewController = FlutterViewController(engine: engine, nibName: nil, bundle: nil)
    flutterViewController.setFlutterViewDidRenderCallback { [unowned self, splashViewController] in
      self.flutterViewDidRenderCallback?()
      
      if (splashViewController != nil) {
        UIView.animate(withDuration: 0.5, animations: {
          splashViewController!.view.alpha = 0
        }, completion: { (_) -> Void in
          splashViewController!.willMove(toParent: nil)
          splashViewController!.view.removeFromSuperview()
          splashViewController!.removeFromParent()
        })
      }
    }
    flutterViewController.willMove(toParent: self)
    addChild(flutterViewController)
    flutterViewController.view.frame = self.view.bounds
    view.addSubview(flutterViewController.view)
    flutterViewController.didMove(toParent: self)
  }
  
  open func providerSplashViewControler() -> UIViewController? {
    return nil
  }
  
  open func configureFlutterEngine(engine: FlutterEngine) -> Void {
  }
  
  open func setFlutterViewDidRenderCallback(callback: @escaping () -> Void) {
    flutterViewDidRenderCallback = callback
  }
  
  deinit {
    AddonFlutterEngineManager.shared.inactiveEngine()
  }
}
