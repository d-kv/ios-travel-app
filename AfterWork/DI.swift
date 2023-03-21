//
//  DI.swift
//  AfterWork
//
//  Created by Евгений Парфененков on 20.03.2023.
//

import Foundation
import Swinject

//let interfaceExt = DI.container.resolve(InterfaceExt.self)!

protocol DIProtocol {
    func getAuthSerivce() -> AuthService
    func getInterfaceExt() -> InterfaceExt
    
    func getMainViewController() -> MainViewController
    func getMainViewPresenter() -> MainViewPresenter
    
    
    func getLoginViewController() -> LoginViewController
    func getSettingsViewController() -> SettingsViewController
    func getMapViewController_Cards() -> MapViewController
    func getMapViewController_Map() -> MapViewController
    func getCardsViewController() -> CardsViewController
    func getCardsViewPresenter() -> CardsViewPresenter
}

class DI: DIProtocol {
    
    func getAuthSerivce() -> AuthService { return container.resolve(AuthService.self)!}
    func getInterfaceExt() -> InterfaceExt { return container.resolve(InterfaceExt.self)! }
    
    func getMainViewController() -> MainViewController { return container.resolve(MainViewController.self)!}
    func getLoginViewController() -> LoginViewController { return container.resolve(LoginViewController.self)!}
    func getSettingsViewController() -> SettingsViewController { return container.resolve(SettingsViewController.self)!}
    func getMapViewController_Cards() -> MapViewController { return container.resolve(MapViewController.self, name: "Cards")!}
    func getMapViewController_Map() -> MapViewController { return container.resolve(MapViewController.self, name: "Map")!}
    func getCardsViewController() -> CardsViewController { return container.resolve(CardsViewController.self)!}
    
    func getMainViewPresenter() -> MainViewPresenter { return container.resolve(MainViewPresenter.self)!}
    func getCardsViewPresenter() -> CardsViewPresenter { return container.resolve(CardsViewPresenter.self)!}
    func getSettingsViewPresenter() -> SettingsViewPresenter { return container.resolve(SettingsViewPresenter.self)!}
    
    static let shared = DI()
    
    private let container: Container = {
        let container = Container()

        container.register(AuthService.self) { _ in return AuthService() }
        container.register(InterfaceExt.self) { _ in return InterfaceExt() }

        container.register(MainViewController.self) { _ in return MainViewController() }
        container.register(LoginViewController.self) { _ in return LoginViewController() }
        container.register(SettingsViewController.self) { _ in return SettingsViewController() }
        container.register(MapViewController.self, name: "Cards") { _ in return MapViewController() }
        container.register(MapViewController.self, name: "Map") { _ in return MapViewController() }
        container.register(CardsViewController.self) { _ in return CardsViewController() }

        container.register(MainViewPresenter.self) { _ in return MainViewPresenter() }
        container.register(CardsViewPresenter.self) { _ in return CardsViewPresenter() }
        container.register(SettingsViewPresenter.self) { _ in return SettingsViewPresenter() }
        

        return container
    }()
        
    static var poiData: PoiData = PoiData.init()
    static let userData: UserData = UserData.init()
}
