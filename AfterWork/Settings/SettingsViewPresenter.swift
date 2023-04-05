//
//  SettingsViewPresenter.swift
//  Tinkoff Travel
//
//  Created by Евгений Парфененков on 02.03.2023.
//

import Foundation
import UIKit
import TinkoffID

protocol SettingsViewPresenterDelegate: AnyObject {
    func settingsViewPresenter(isLoading: Bool)
}

final class SettingsViewPresenter {
        
    func signOut() {
        
        DI.shared.getAuthSerivce().logOut(accessToken: AuthService.getSecret(key: "accessToken"), handler: handleSignOut)
    }
    
    private func handleSignOut(_ result: Result<Void, Error>) {
        AuthService.setSecret(key: "accessToken", value: "")
        AuthService.setSecret(key: "refreshToken", value: "")
        AuthService.setSecret(key: "idToken", value: "")
        
        let loginViewController = DI.shared.getLoginViewController()
        loginViewController.modalPresentationStyle = .fullScreen
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        sceneDelegate.window!.rootViewController?.dismiss(animated: true)
        sceneDelegate.window!.rootViewController?.present(loginViewController, animated: true)
    }
    
}
