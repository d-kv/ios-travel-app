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

    
//    static let container: Container = {
//        let container = Container()
//        
//        container.register(AuthService.self) { _ in return AuthService() }
//        container.register(InterfaceExt.self) { _ in return InterfaceExt() }
//        container.register(MapViewController.self) { _ in return MapViewController() }
//        
//        return container
//    }()
//    
//    func application(_ application: UIApplication, open url: URL, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        // Override point for customization after application launch.
//        
//        AppDelegate.container.resolve(AuthService.self)!.tinkoffId.handleCallbackUrl(url)
//    }
}

extension AppDelegate {
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions:
                   [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [
            .badge, .sound, .alert
        ]) { granted, _ in
            guard granted else { return }
          
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.reduce("") { $0 + String(format: "%02x", $1) }
        print("token: \(token)")
    }
}
