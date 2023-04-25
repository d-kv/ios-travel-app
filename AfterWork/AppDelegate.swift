//
//  AppDelegate.swift
//  Tinkoff Travel
//
//  Created by Евгений Парфененков on 20.02.2023.
//

import UIKit
import TinkoffID
import Swinject
import FirebaseCore
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {

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
        FirebaseApp.configure()

        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        return true
    }

    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )

    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // let token = deviceToken.reduce("") { $0 + String(format: "%02x", $1) }
    }
}
