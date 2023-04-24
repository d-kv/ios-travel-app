//
//  SceneDelegate.swift
//  Tinkoff Travel
//
//  Created by Евгений Парфененков on 20.02.2023.
//

import UIKit
import TinkoffID
import Swinject

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = DI.shared.getMainViewController()
        window?.makeKeyAndVisible()
        window?.overrideUserInterfaceStyle = .dark
        
        if CacheImpl.shared.getSecret(key: "idToken") == ""  {
            let loginViewController = DI.shared.getLoginViewController()
            loginViewController.modalPresentationStyle = .fullScreen
            
            let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
            sceneDelegate.window!.rootViewController?.present(loginViewController, animated: true)
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let firstUrl = URLContexts.first?.url else {
            return
        }
        
        if DI.tinkoffId.isTinkoffAuthAvailable {
            _ = DI.tinkoffId.handleCallbackUrl(firstUrl)
        } else {
            _ = DI.debugTinkoffId.handleCallbackUrl(firstUrl)
        }
    }
}

