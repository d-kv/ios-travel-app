//
//  SceneDelegate.swift
//  Tinkoff Travel
//
//  Created by Евгений Парфененков on 20.02.2023.
//

import UIKit
import TinkoffID
import Swinject
import CoreLocation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let notificationCenter = NotificationCenter.default
    private var observer: NSObjectProtocol?
    
    func observerNotification() {
        notificationCenter.addObserver(forName: .sharedLocation, object: nil, queue: .main) { notification in
            
            guard let object = notification.object as? [String: Any] else { return }
            guard let error = object["error"] as? Bool else { return }
            
            if error {
                print("error to access location service.")
            } else {
                guard let location = object["location"] as? CLLocation else { return }
                currentLocation = location
                print("location: \(location.coordinate.latitude)")
            }
        }
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        LocationManager.shared.checkLocationService()
        observerNotification()
        
        observer = notificationCenter.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main, using: { notification in
            print("willEnterForegroundNotification")
            //LocationManager.shared.checkLocationService()
        })

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let cache = CacheImpl.shared

        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = DI.shared.getMainViewController()
        window?.makeKeyAndVisible()
        window?.overrideUserInterfaceStyle = .dark

        if cache.getIdToken() == "" {
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
