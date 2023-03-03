//
//  LoginViewPresenter.swift
//  Tinkoff Travel
//
//  Created by Евгений Парфененков on 02.03.2023.
//

import Foundation
import UIKit


protocol LoginViewPresenterDelegate: class {
    func loginViewPresenter(_ reposViewModel: LoginViewPresenter,
                            isLoading: Bool)
    func loginViewPresenter(_ reposViewModel: LoginViewPresenter,
                            didReceiveRepos repos: [LoginViewPresenter])
    func loginViewPresenter(_ reposViewModel: LoginViewPresenter,
                            didSelectId id: Int)
}

class LoginViewPresenter {
    weak var delegate: LoginViewPresenterDelegate?
    
    
}
