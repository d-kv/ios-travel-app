//
//  LoginViewPresenter.swift
//  Tinkoff Travel
//
//  Created by Евгений Парфененков on 02.03.2023.
//

import Foundation
import UIKit


protocol LoginViewPresenterDelegate: AnyObject {
    func loginViewPresenter(_ reposViewModel: LoginViewPresenter,
                            isLoading: Bool)
    //func loginViewPresenter(isLoading: Bool)
//    func loginViewPresenter(_ reposViewModel: LoginViewPresenter,
//                            didReceiveRepos repos: [LoginViewPresenter])
//    func loginViewPresenter(_ reposViewModel: LoginViewPresenter,
//                            didSelectId id: Int)
}

class LoginViewPresenter {
    weak var delegate: LoginViewPresenterDelegate?
    
    //var loginViewController = LoginViewController()
    
    func ready() {
        //delegate?.loginViewPresenter(isLoading: true)
    }
    
    @objc func authButtonClicked() {
        //loginViewController.view.showBlurLoader()
        
        //delegate?.loginViewPresenter(isLoading: true)
        delegate?.loginViewPresenter(self, isLoading: true)
        
        print("Authed!!!")
        //goToMain()
    }
    
    private func goToMain() {
        let mainViewController = MainViewController()
        mainViewController.modalPresentationStyle = .currentContext
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        sceneDelegate.window!.rootViewController?.present(mainViewController, animated: true)
    }
}
