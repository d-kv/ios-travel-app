//
//  LoginViewController.swift
//  Tinkoff Travel
//
//  Created by Евгений Парфененков on 02.03.2023.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    let logos = UIImageView(image: UIImage(named: "TINHSE"))
    let enterButton = UIButton()
    let bigText = DI.shared.getInterfaceExt().standardTextView(text: String(localized: "login_big"), textColor: .white, font: .boldSystemFont(ofSize: 30))
    let smallText = DI.shared.getInterfaceExt().standardTextView(text: String(localized: "login_small"), textColor: .gray, font: .systemFont(ofSize: 12))
    let loginViewPresenter:LoginViewPresenter = LoginViewPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginViewPresenter.delegate = self
        
        creation()
        constraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = UIColor(named: "GreyColor")
    }
    
    @objc func authButtonClicked() {
        loginViewPresenter.authButtonClicked()
    }
    
    func creation() {
        enterButton.setImage(UIImage(named: "TINIDbutton"), for: .normal)
        enterButton.addTarget(self, action: #selector(authButtonClicked), for: .touchUpInside)
    }
    
    func constraints() {
        logos.translatesAutoresizingMaskIntoConstraints = false
        let logosConstraints = [
            logos.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            logos.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logos.widthAnchor.constraint(equalToConstant: 215),
            logos.heightAnchor.constraint(equalToConstant: 100)
        ]
        
        bigText.translatesAutoresizingMaskIntoConstraints = false
        let bigTextConstraints = [
            bigText.topAnchor.constraint(equalTo: view.topAnchor, constant: 240),
            bigText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //logos.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            bigText.widthAnchor.constraint(equalToConstant: 270),
            bigText.heightAnchor.constraint(equalToConstant: 80)
        ]
        
        smallText.translatesAutoresizingMaskIntoConstraints = false
        let smallTextConstraints = [
            smallText.topAnchor.constraint(equalTo: bigText.bottomAnchor, constant: 0),
            smallText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //logos.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            smallText.widthAnchor.constraint(equalToConstant: 270),
            smallText.heightAnchor.constraint(equalToConstant: 20)
        ]

        enterButton.translatesAutoresizingMaskIntoConstraints = false
        let enterButtonConstraints = [
            enterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            enterButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            enterButton.widthAnchor.constraint(equalToConstant: 270),
            enterButton.heightAnchor.constraint(equalToConstant: 55)
        ]
        
        view.addSubview(logos)
        //NSLayoutConstraint.activate(logosConstraints)
        
        view.addSubview(bigText)
        //NSLayoutConstraint.activate(bigTextConstraints)
        
        view.addSubview(smallText)
        //NSLayoutConstraint.activate(smallTextConstraints)
        
        view.addSubview(enterButton)
        //NSLayoutConstraint.activate(enterButtonConstraints)
        
        let constraintsArray = [logosConstraints, bigTextConstraints, smallTextConstraints, enterButtonConstraints].flatMap{$0}
        NSLayoutConstraint.activate(constraintsArray)
    }
    
    func showAlert(text: String!) {
        let alert = UIAlertController(title: "Что-то не так...", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension LoginViewController: LoginViewPresenterDelegate {
    func TinkoffIDResolver(status: StatusCodes) {
        switch status {
        case .waiting:
            self.view.removeBluerLoader()
        case .proceed:
            self.view.showBlurLoader()
        case .failedToLaunch:
            self.view.removeBluerLoader()
            showAlert(text: "TINKOFF: Невозможно открыть приложение Tinkoff")
        case .cancelledByUser:
            self.view.removeBluerLoader()
            showAlert(text: "TINKOFF: Вход отменен")
        case .unavailable:
            self.view.removeBluerLoader()
            showAlert(text: "TINKOFF: В данный момент невозможно выполнить вход")
        case .failedToObtainToken:
            self.view.removeBluerLoader()
            showAlert(text: "TINKOFF: Произошла неизвестная ошибка (Токен)")
        case .failedToRefreshCredentials:
            self.view.removeBluerLoader()
            showAlert(text: "TINKOFF: Произошла неизвестная ошибка (Обновление)")
        case .unknownError:
            showAlert(text: "TINKOFF: Произошла неизвестная ошибка (Токен)")
            self.view.removeBluerLoader()
        case .someError:
            showAlert(text: "Произошла неизвестная ошибка, повторите попытку позже")
            self.view.removeBluerLoader()
        case .failTID:
            showAlert(text: "Произошла ошибка с получением данных, повторите попытку позже")
            self.view.removeBluerLoader()
        case .serverError:
            showAlert(text: "Произошла неизвестная ошибка, повторите попытку позже")
            self.view.removeBluerLoader()
        case .notTester:
            showAlert(text: "К сожалению, в данный момент проходит тестирование приложения")
            self.view.removeBluerLoader()
        case .blocked:
            showAlert(text: "Ваш аккаунт заморожен, обратитесь к разработчику")
            self.view.removeBluerLoader()
        }

    }
    
    func loginViewPresenter(_ reposViewModel: LoginViewPresenter, isLoading: Bool) {
        if isLoading { self.view.showBlurLoader() }
        else { self.view.removeBluerLoader() }
    }
    
}

