//
//  LoginViewPresenter.swift
//  Tinkoff Travel
//
//  Created by Евгений Парфененков on 02.03.2023.
//

import Foundation
import UIKit
import TinkoffID

// MARK: - Protocols

protocol LoginViewPresenterDelegate: AnyObject {
    func loginViewPresenter(_ reposViewModel: LoginViewPresenter,
                            isLoading: Bool)
}

// MARK: - Main methods and Class

class LoginViewPresenter {

    weak var delegate: LoginViewPresenterDelegate?
    
    let clientId = "tid_afterwork-mb"
    let callbackUrl = "afterwork://"
    
    var credentials: TinkoffTokenPayload! = nil
    static var tinkoffId: ITinkoffID! = nil
    
    @objc func authButtonClicked() { authTID() }
    
    private func goToMain() {
        let mainViewController = MainViewController()
        mainViewController.modalPresentationStyle = .currentContext
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        sceneDelegate.window!.rootViewController?.present(mainViewController, animated: true)
    }
    
    // MARK: - Tinkoff ID Auth
    
    func authTID() {
        
        let factory = TinkoffIDFactory(clientId: clientId, callbackUrl: callbackUrl)
        LoginViewPresenter.tinkoffId = factory.build()
        
        if LoginViewPresenter.tinkoffId.isTinkoffAuthAvailable {
            LoginViewPresenter.tinkoffId.startTinkoffAuth(handleSignInResult(_:))
        } else {
            let configuration = DebugConfiguration(canRefreshTokens: true, canLogout: true)

            let factory: ITinkoffIDFactory = DebugTinkoffIDFactory(callbackUrl: callbackUrl, configuration: configuration)

            LoginViewPresenter.debugTinkoffId = factory.build()
            LoginViewPresenter.debugTinkoffId.startTinkoffAuth(handleSignInResult(_:))
        }
    }
    
    
    // MARK: - Tinkoff ID Debug
    
    static var debugTinkoffId: ITinkoffID!
    func authTIDdebug() { LoginViewPresenter.debugTinkoffId.startTinkoffAuth(handleSignInResult(_:)) }
    
    // MARK: - Tinkoff ID CallBack handler
    
    private func handleSignInResult(_ result: Result<TinkoffTokenPayload, TinkoffAuthError>) {
        delegate?.loginViewPresenter(self, isLoading: false)
        goToMain()
        do {
            credentials = try result.get()
            
            print("Her", credentials as Any, credentials.accessToken)
        } catch TinkoffAuthError.cancelledByUser {
            print("❌ Auth process cancelled by a user")
        } catch {
            print("❌ \(error)")
        }
        print("Zhopa", result)
    }
}
