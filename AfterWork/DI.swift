//
//  DI.swift
//  AfterWork
//
//  Created by Евгений Парфененков on 20.03.2023.
//

import Foundation
import Swinject

class DI {
  static let container: Container = {
    let container = Container()

    container.register(AuthService.self) { _ in AuthService() }
    container.register(InterfaceExt.self) { _ in InterfaceExt() }

    container.register(MainViewController.self) { _ in MainViewController() }
    container.register(LoginViewController.self) { _ in LoginViewController() }
    container.register(SettingsViewController.self) { _ in SettingsViewController() }
    container.register(MapViewController.self, name: "Cards") { _ in MapViewController() }
    container.register(MapViewController.self, name: "Map") { _ in MapViewController() }
    container.register(CardsViewController.self) { _ in CardsViewController() }

    container.register(CardsViewPresenter.self) { _ in CardsViewPresenter() }

    return container
  }()
}
