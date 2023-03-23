//
//  SettingsViewPresenter.swift
//  Tinkoff Travel
//
//  Created by Евгений Парфененков on 02.03.2023.
//

import Foundation
import TinkoffID
import UIKit

// MARK: - SettingsViewPresenterDelegate

protocol SettingsViewPresenterDelegate: AnyObject {
  func settingsViewPresenter(isLoading: Bool)
}

// MARK: - SettingsViewPresenter

final class SettingsViewPresenter {
  // MARK: Internal

  let preferences = UserDefaults.standard

  func signOut() {
    DI.shared.getAuthService()
      .logOut(accessToken: preferences.string(forKey: "accessToken")!, handler: handleSignOut)
  }

  // MARK: Private

  private func handleSignOut(_ result: Result<(), Error>) {
    preferences.removeObject(forKey: "accessToken")
    preferences.removeObject(forKey: "refreshToken")
    preferences.removeObject(forKey: "idToken")

    let loginViewController = DI.shared.getLoginViewController()
    loginViewController.modalPresentationStyle = .fullScreen

    let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    sceneDelegate.window!.rootViewController?.dismiss(animated: true)
    sceneDelegate.window!.rootViewController?.present(loginViewController, animated: true)
  }
}
