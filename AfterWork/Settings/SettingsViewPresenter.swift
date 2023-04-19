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
        
        DI.shared.getAuthSerivce().logOut(accessToken: AuthServiceImpl.shared.getSecret(key: "accessToken"), handler: handleSignOut)
    }
    
    private func handleSignOut(_ result: Result<Void, Error>) {
        AuthServiceImpl.shared.setSecret(key: "accessToken", value: "")
        AuthServiceImpl.shared.setSecret(key: "refreshToken", value: "")
        AuthServiceImpl.shared.setSecret(key: "idToken", value: "")
        
        let loginViewController = DI.shared.getLoginViewController()
        loginViewController.modalPresentationStyle = .fullScreen
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        sceneDelegate.window!.rootViewController?.dismiss(animated: true)
        sceneDelegate.window!.rootViewController?.present(loginViewController, animated: true)
    }
    
}
