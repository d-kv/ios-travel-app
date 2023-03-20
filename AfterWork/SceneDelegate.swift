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
    let container = AppDelegate.container

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = MainViewController()
        window?.makeKeyAndVisible()
        window?.overrideUserInterfaceStyle = .dark        
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let firstUrl = URLContexts.first?.url else {
            return
        }
        
        //let authService = AppDelegate.container.resolve(AuthService.self)!
        if AuthService.tinkoffId.isTinkoffAuthAvailable {
            _ = AuthService.tinkoffId.handleCallbackUrl(firstUrl)
        } else {
            _ = AuthService.debugTinkoffId.handleCallbackUrl(firstUrl)
        }
        NSLog(firstUrl.absoluteString, 1)
        //print(firstUrl.absoluteString)
    }
    
    
//    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
//        
//        if let url = URLContexts.first?.url {
//            let authService = container.resolve(AuthService.self)!
//            authService.tinkoffId.handleCallbackUrl(url)
//            print(url)
////            if tinkoffId!.isTinkoffAuthAvailable {
////                tinkoffId!.handleCallbackUrl(url) }
////
////            else { LoginViewPresenter.debugTinkoffId.handleCallbackUrl(url) }
//        }
//    }
}

