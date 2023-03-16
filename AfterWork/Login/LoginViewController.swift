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
    let bigText = UITextView(frame: CGRect(x: 20.0, y: 90.0, width: 250.0, height: 100.0))
    let smallText = UITextView(frame: CGRect(x: 20.0, y: 90.0, width: 250.0, height: 100.0))
    let loginViewPresenter:LoginViewPresenter = LoginViewPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginViewPresenter.delegate = self
        
        bigText.text = "Вход с помощью Tinkoff ID"
        bigText.contentInsetAdjustmentBehavior = .automatic
        bigText.center = self.view.center
        bigText.textAlignment = NSTextAlignment.justified
        bigText.textColor = .white
        bigText.backgroundColor = .clear
        bigText.font = UIFont(name: "Helvetica Neue Bold", size: 30)
        bigText.adjustsFontForContentSizeCategory = false
        bigText.isEditable = false
        bigText.sizeToFit()
        
        smallText.text = "Вход доступен только для сотрудников"
        smallText.contentInsetAdjustmentBehavior = .automatic
        smallText.center = self.view.center
        smallText.textAlignment = NSTextAlignment.justified
        smallText.textColor = .gray
        smallText.backgroundColor = .clear
        smallText.font = UIFont(name: "Helvetica Neue Regular", size: 12)
        smallText.adjustsFontForContentSizeCategory = false
        smallText.isEditable = false
        smallText.sizeToFit()
        
        enterButton.setImage(UIImage(named: "TINIDbutton"), for: .normal)
        enterButton.addTarget(self, action: #selector(authButtonClicked), for: .touchUpInside)
        
        constraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = UIColor(named: "GreyColor")
    }
    
    @objc func authButtonClicked() {
        loginViewPresenter.authButtonClicked()
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
//        switch status {
//            case 0: //0 - waiting
//                self.view.removeBluerLoader()
//            case 1: //1 - auth process
//                self.view.showBlurLoader()
//            case 2: //2 - success login;
//                self.view.showBlurLoader()
//            case 3: //3 - login canceled
//                self.view.removeBluerLoader()
//                showAlert(text: "Вы отменили авторизацию")
//            case 4: //4 - login failed
//                self.view.removeBluerLoader()
//                showAlert(text: "Авторизация не получилась")
//            case 5:
//                self.view.removeBluerLoader()
//            default:  //5 - some mistake
//                self.view.removeBluerLoader()
//                showAlert(text: "Произошла неизвестная ошибка")
//        }\
        switch status {
            
        case .waiting:
            self.view.removeBluerLoader()
        case .proceed:
            self.view.showBlurLoader()
        case .failedToLaunch:
            self.view.removeBluerLoader()
            showAlert(text: "Невозможно открыть приложение Tinkoff")
        case .cancelledByUser:
            self.view.removeBluerLoader()
            showAlert(text: "Вход отменен")
        case .unavailable:
            self.view.removeBluerLoader()
            showAlert(text: "В данный момент невозможно выполнить вход")
        case .failedToObtainToken:
            self.view.removeBluerLoader()
            showAlert(text: "Произошла неизвестная ошибка (Токен)")
        case .failedToRefreshCredentials:
            self.view.removeBluerLoader()
            showAlert(text: "Произошла неизвестная ошибка (Обновление)")
        case .unknownError:
            showAlert(text: "Произошла неизвестная ошибка (Токен)")
            self.view.removeBluerLoader()
        }
    
    }
    
    func loginViewPresenter(_ reposViewModel: LoginViewPresenter, isLoading: Bool) {
        if isLoading { self.view.showBlurLoader() }
        else { self.view.removeBluerLoader() }
    }
    
}

