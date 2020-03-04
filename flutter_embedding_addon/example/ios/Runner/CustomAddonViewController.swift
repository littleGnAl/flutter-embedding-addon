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
import os.log
import flutter_embedding_addon

class CustomAddonViewController: AddonFlutterViewController {
  
  private var navigationChannel: NativeNavigationChannel? = nil
  
  private let displayInitialRoute: String
  
  init(displayInitialRoute: String) {
    self.displayInitialRoute = displayInitialRoute
    super.init(nibName: nil, bundle: nil)
    
    setFlutterViewDidRenderCallback { [unowned self] in
      self.navigationChannel?.pushReplacementNamed(routeName: self.displayInitialRoute)
    }
  }
  
  required init?(coder: NSCoder) {
    displayInitialRoute = "/"
    super.init(coder: coder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white
  }
  
  override func configureFlutterEngine(engine: FlutterEngine) {
    navigationChannel = NativeNavigationChannel(
      messenger: engine.binaryMessenger,
      pushRouteCallback: { [unowned self] routeName in
        let viewController = CustomAddonViewController(
          displayInitialRoute: routeName)
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
      },
      popCallback: { [weak self] in
        self?.dismiss(animated: true, completion: nil)
      })
  }
  
  override func providerSplashViewControler() -> UIViewController? {
    return SplashViewController()
  }
}
