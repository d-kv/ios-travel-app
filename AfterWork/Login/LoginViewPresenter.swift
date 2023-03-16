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
    func TinkoffIDResolver(status: StatusCodes) // 0 - waiting; 1 - auth process; 2 - success login; 3 - login canceled; 4 - login failed; 5 - some mistake
}

// MARK: - Main methods and Class

class LoginViewPresenter {

    weak var delegate: LoginViewPresenterDelegate?
        
    let container = AppDelegate.container

    
    @objc func authButtonClicked() {
        delegate?.TinkoffIDResolver(status: StatusCodes.proceed)
        
        let authService = container.resolve(AuthService.self)!
        authService.TinkoffIDAuth(handler: handleSignInResult)
        
    }
    
    private func goToMain() {
        let mainViewController = MainViewController()
        mainViewController.modalPresentationStyle = .fullScreen
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        sceneDelegate.window!.rootViewController?.present(mainViewController, animated: true)
        sceneDelegate.window!.rootViewController?.dismiss(animated: true)
    }
    
    // MARK: - Auth handler
    
    private var credentials: TinkoffTokenPayload!
    
    private func handleSignInResult(_ result: Result<TinkoffTokenPayload, TinkoffAuthError>) {
        do {
            credentials = try result.get()
            delegate?.TinkoffIDResolver(status: StatusCodes.waiting)
        } catch TinkoffAuthError.cancelledByUser {
            delegate?.TinkoffIDResolver(status: StatusCodes.cancelledByUser)
        } catch TinkoffAuthError.failedToLaunchApp {
            delegate?.TinkoffIDResolver(status: StatusCodes.failedToLaunch)
        } catch TinkoffAuthError.failedToObtainToken {
            delegate?.TinkoffIDResolver(status: StatusCodes.failedToObtainToken)
        } catch TinkoffAuthError.unavailable {
            delegate?.TinkoffIDResolver(status: StatusCodes.unavailable)
        } catch {
            delegate?.TinkoffIDResolver(status: StatusCodes.unknownError)
            NSLog("AuthError", 1)
        }
    }
}

enum StatusCodes {
    case waiting
    case proceed
    case failedToLaunch
    case cancelledByUser
    case unavailable
    case failedToObtainToken
    case failedToRefreshCredentials
    case unknownError
}
