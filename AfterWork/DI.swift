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
        
        container.register(AuthService.self) { _ in return AuthService() }
        container.register(InterfaceExt.self) { _ in return InterfaceExt() }
        
        container.register(MainViewController.self) { _ in return MainViewController() }
        container.register(LoginViewController.self) { _ in return LoginViewController() }
        container.register(SettingsViewController.self) { _ in return SettingsViewController() }
        container.register(MapViewController.self, name: "Cards") { _ in return MapViewController() }
        container.register(MapViewController.self, name: "Map") { _ in return MapViewController() }
        container.register(CardsViewController.self) { _ in return CardsViewController() }
        
        container.register(CardsViewPresenter.self) { _ in return CardsViewPresenter() }
        
        return container
    }()
    
    
}
