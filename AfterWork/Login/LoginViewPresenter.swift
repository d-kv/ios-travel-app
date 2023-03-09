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
    //func loginViewPresenter(isLoading: Bool)
//    func loginViewPresenter(_ reposViewModel: LoginViewPresenter,
//                            didReceiveRepos repos: [LoginViewPresenter])
//    func loginViewPresenter(_ reposViewModel: LoginViewPresenter,
//                            didSelectId id: Int)
}

// MARK: - Main methods and Class

class LoginViewPresenter {

    weak var delegate: LoginViewPresenterDelegate?
    
    let clientId = ""
    let callbackUrl = "afterwork://"
    
    func ready() {
        //delegate?.loginViewPresenter(isLoading: true)
    }
    
    var credentials: TinkoffTokenPayload! = nil
    
    @objc func authButtonClicked() {
        //delegate?.loginViewPresenter(self, isLoading: true)
        
        //authTIDdebug()
        authTID()
        
    }
    
    private func goToMain() {
        let mainViewController = MainViewController()
        mainViewController.modalPresentationStyle = .currentContext
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        sceneDelegate.window!.rootViewController?.present(mainViewController, animated: true)
    }
    
    // MARK: - Tinkoff ID Auth
    
    static var tinkoffId: ITinkoffID! = nil
    
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
    
    
    func authTIDdebug() {
        //let callbackUrl: String = "afterwork://good"

        // Конфигурация для отладки
        
//        debugTinkoffId.startTinkoffAuth { result in
//            do {
//                let payload = try result.get()
//                print("Access token obtained: \(payload.accessToken)")
//                
//            } catch {
//                print("ZHOPA", error)
//            }
//        }
        
        //debugTinkoffId.handleCallbackUrl(URL(string: "afterwork://good?result=success")!)
        LoginViewPresenter.debugTinkoffId.startTinkoffAuth(handleSignInResult(_:))
        
    }
    
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
