//
//  MainViewPresenter.swift
//  Tinkoff Travel
//
//  Created by Евгений Парфененков on 02.03.2023.
//

import Foundation
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
  weak var delegate: MainViewPresenterDelegate?

  static func openSettings() {
    let settingsViewController = DI.container.resolve(SettingsViewController.self)!
    // settingsViewController.modalPresentationStyle = .fullScreen

    let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    sceneDelegate.window!.rootViewController?.present(settingsViewController, animated: true)
  }

  static func goToMap() {
    let mapViewController = DI.container.resolve(MapViewController.self, name: "Map")!
    mapViewController.modalPresentationStyle = .fullScreen

    let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    // sceneDelegate.window!.rootViewController?.dismiss(animated: true)
    sceneDelegate.window!.rootViewController?.present(mapViewController, animated: true)
  }

  static func goToCards() {
    let cardsViewController = DI.container.resolve(CardsViewController.self)!
    cardsViewController.modalPresentationStyle = .fullScreen

    let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    // sceneDelegate.window!.rootViewController?.dismiss(animated: true)
    sceneDelegate.window!.rootViewController?.present(cardsViewController, animated: true)
  }

  func ready() {
    delegate?.mainViewPresenter(self, isLoading: true)
  }
}
