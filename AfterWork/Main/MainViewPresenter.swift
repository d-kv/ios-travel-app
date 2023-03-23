//
//  MainViewPresenter.swift
//  Tinkoff Travel
//
//  Created by Евгений Парфененков on 02.03.2023.
//

import Foundation
import TinkoffID
import UIKit

// MARK: - MainViewPresenterDelegate

protocol MainViewPresenterDelegate: AnyObject {
  func mainViewPresenter(
    _ reposViewModel: MainViewPresenter,
    isLoading: Bool
  )
}

// MARK: - MainViewPresenter

final class MainViewPresenter {
  // MARK: Internal

  weak var delegate: MainViewPresenterDelegate?

  let preferences = UserDefaults.standard

  func openSettings() {
    let settingsViewController = DI.shared.getSettingsViewController()

    let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    sceneDelegate.window!.rootViewController?.present(settingsViewController, animated: true)
  }

  func goToMap() {
    let mapViewController = DI.shared.getMapViewController_Map()
    mapViewController.modalPresentationStyle = .fullScreen

    let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    sceneDelegate.window!.rootViewController?.present(mapViewController, animated: true)
  }

  func goToCards() {
    let cardsViewController = DI.shared.getCardsViewController()
    cardsViewController.modalPresentationStyle = .fullScreen

    let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    sceneDelegate.window!.rootViewController?.present(cardsViewController, animated: true)
  }

  func goToLogin() {
    let loginViewController = DI.shared.getLoginViewController()
    loginViewController.modalPresentationStyle = .fullScreen

    let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    sceneDelegate.window!.rootViewController?.present(loginViewController, animated: true)
  }

  func enteredApp() {
    delegate?.mainViewPresenter(self, isLoading: true)

    if !AuthService.tinkoffId.isTinkoffAuthAvailable {
      delegate?.mainViewPresenter(self, isLoading: false)
      DataLoader.loadData()
    } else {
      if preferences.string(forKey: "idToken") ?? nil != nil {
        let refreshToken = preferences.string(forKey: "refreshToken") ?? ""

        AuthService.tinkoffId.obtainTokenPayload(using: refreshToken, handleRefreshToken)
      } else {
        delegate?.mainViewPresenter(self, isLoading: false)
        goToLogin()
      }
    }
  }

  // MARK: Private

  private func handleRefreshToken(_ result: Result<TinkoffTokenPayload, TinkoffAuthError>) {
    do {
      let credentials = try result.get()

      preferences.set(credentials.idToken, forKey: "idToken")
      preferences.set(credentials.accessToken, forKey: "accessToken")
      preferences.set(credentials.refreshToken, forKey: "refreshToken")

      DataLoader.loadData()

      delegate?.mainViewPresenter(self, isLoading: false)
    } catch {
      delegate?.mainViewPresenter(self, isLoading: false)
      goToLogin()
    }
  }
}
