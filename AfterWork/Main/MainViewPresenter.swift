//
//  MainViewPresenter.swift
//  Tinkoff Travel
//
//  Created by Евгений Парфененков on 02.03.2023.
//

import Foundation
import UIKit
import TinkoffID

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
    
    let preferences = UserDefaults.standard
    
    func enteredApp() {
        
        self.delegate?.mainViewPresenter(self, isLoading: true)
        
        if !AuthService.tinkoffId.isTinkoffAuthAvailable {
            self.delegate?.mainViewPresenter(self, isLoading: false)
            DataLoader.loadData()
        } else {
            if preferences.string(forKey: "idToken") ?? nil != nil {
                
                let refreshToken = preferences.string(forKey: "refreshToken") ?? ""
                
                AuthService.tinkoffId.obtainTokenPayload(using: refreshToken, handleRefreshToken)
            } else {
                print("ZHOPA")
                self.delegate?.mainViewPresenter(self, isLoading: false)
                goToLogin()
            }
        }
    }
    
    private func handleRefreshToken(_ result: Result<TinkoffTokenPayload, TinkoffAuthError>) {
        do {
            let credentials = try result.get()
            
            preferences.set(credentials.idToken, forKey: "idToken")
            preferences.set(credentials.accessToken, forKey: "accessToken")
            preferences.set(credentials.refreshToken, forKey: "refreshToken")
            
            print("HUY1", credentials)
            
            DataLoader.loadData()
            
            self.delegate?.mainViewPresenter(self, isLoading: false)
        } catch {
            print("HUY2")
            self.delegate?.mainViewPresenter(self, isLoading: false)
            goToLogin()
        }
    }
}
