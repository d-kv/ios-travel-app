//
//  SettingsViewPresenter.swift
//  Tinkoff Travel
//
//  Created by Евгений Парфененков on 02.03.2023.
//

import Foundation
import UIKit

// MARK: - SettingsViewPresenterDelegate

protocol SettingsViewPresenterDelegate: AnyObject {
  func settingsViewPresenter(isLoading: Bool)
}

// MARK: - SettingsViewPresenter

enum SettingsViewPresenter {
  static func signOut() {
    DispatchQueue.main.async {
      let loginViewController = DI.container.resolve(LoginViewController.self)!
      loginViewController.modalPresentationStyle = .fullScreen

      let sceneDelegate = UIApplication.shared.connectedScenes.first!
        .delegate as! SceneDelegate
      sceneDelegate.window!.rootViewController?.dismiss(animated: true)
      sceneDelegate.window!.rootViewController?.present(loginViewController, animated: true)
    }
  }
}
