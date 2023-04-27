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
    func signOut()
}

final class SettingsViewPresenter {

    let cache = CacheImpl.shared
    
    func signOut() {

        DI.shared.getAuthService().logOut(accessToken: cache.getAccessToken(), handler: handleSignOut)
    }

    private func handleSignOut(_ result: Result<Void, Error>) {
        cache.setAccessToken(value: "")
        cache.setRefreshToken(value: "")
        cache.setIdToken(value: "")

        let loginViewController = DI.shared.getLoginViewController()
        loginViewController.modalPresentationStyle = .fullScreen

        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        sceneDelegate.window!.rootViewController?.dismiss(animated: true)
        sceneDelegate.window!.rootViewController?.present(loginViewController, animated: true)
    }

}
