//
//  AppDelegate.swift
//  Tinkoff Travel
//
//  Created by Евгений Парфененков on 20.02.2023.
//

import UIKit
import TinkoffID
import Swinject

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static let container: Container = {
        let container = Container()
        container.register(AuthService.self) { _ in return AuthService() }
        return container
    }()
    
//    func application(_ application: UIApplication, open url: URL, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        // Override point for customization after application launch.
//        
//        AppDelegate.container.resolve(AuthService.self)!.tinkoffId.handleCallbackUrl(url)
//    }
}
