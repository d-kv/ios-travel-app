//
//  SceneDelegate.swift
//  Tinkoff Travel
//
//  Created by Евгений Парфененков on 20.02.2023.
//

import Swinject
import TinkoffID
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  let container = DI.container

    var window: UIWindow?

  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    guard let firstUrl = URLContexts.first?.url else {
      return
    }

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        if UserDefaults.standard.string(forKey: "idToken") != nil { window?.rootViewController = DI.shared.getMainViewController() }
        else { window?.rootViewController = DI.shared.getLoginViewController() }
        window?.makeKeyAndVisible()
        window?.overrideUserInterfaceStyle = .dark        
    }
    NSLog(firstUrl.absoluteString, 1)
  }
}
