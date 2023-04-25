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
    let loginViewPresenter: LoginViewPresenter = LoginViewPresenter()
    let alphaText = UIButton()

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

        alphaText.setTitle(
            "alpha_test_" +
            (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")
            + "_" +
            (Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""),
            for: .normal
        )
        alphaText.addTarget(self, action: #selector(alphaTap), for: .touchUpInside)
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
            bigText.widthAnchor.constraint(equalToConstant: 270),
            bigText.heightAnchor.constraint(equalToConstant: 80)
        ]

        smallText.translatesAutoresizingMaskIntoConstraints = false
        let smallTextConstraints = [
            smallText.topAnchor.constraint(equalTo: bigText.bottomAnchor, constant: 0),
            smallText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
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

        alphaText.translatesAutoresizingMaskIntoConstraints = false
        let alphaTextConstraints = [
            alphaText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alphaText.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        ]

        view.addSubview(logos)
        view.addSubview(bigText)
        view.addSubview(smallText)
        view.addSubview(enterButton)
        view.addSubview(alphaText)

        let constraintsArray = [logosConstraints, bigTextConstraints, smallTextConstraints, enterButtonConstraints, alphaTextConstraints].flatMap {$0}
        NSLayoutConstraint.activate(constraintsArray)
    }

    @objc func alphaTap() {
        alphaAlert()
    }

    func alphaAlert() {
        let alert = UIAlertController(title: "DEBUG", message: "Enter a key to enter debug mode", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = "enter key"
            textField.textContentType = .password
            textField.text = "50b058b183f17a54ac3cd66652a227ab"
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
            alert?.dismiss(animated: true)
        }))

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [self, weak alert] (_) in
            let textField = alert?.textFields?[0]
            if textField?.text != nil { loginViewPresenter.debug_req(TIN_accessToken: textField?.text ?? "") }
            alert?.isEditing = false

        }))

        self.present(alert, animated: true)
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
            showAlert(text: String(localized: "error_failedToLaunch"))
        case .cancelledByUser:
            self.view.removeBluerLoader()
            showAlert(text: String(localized: "error_cancelledByUser"))
        case .unavailable:
            self.view.removeBluerLoader()
            showAlert(text: String(localized: "error_unavailable"))
        case .failedToObtainToken:
            self.view.removeBluerLoader()
            showAlert(text: String(localized: "error_failedToObtainToken"))
        case .failedToRefreshCredentials:
            self.view.removeBluerLoader()
            showAlert(text: String(localized: "error_failedToRefreshCredentials"))
        case .unknownError:
            showAlert(text: String(localized: "error_unknownError"))
            self.view.removeBluerLoader()
        case .someError:
            showAlert(text: String(localized: "error_someError"))
            self.view.removeBluerLoader()
        case .failTID:
            showAlert(text: String(localized: "error_failTID"))
            self.view.removeBluerLoader()
        case .serverError:
            showAlert(text: String(localized: "error_serverError"))
            self.view.removeBluerLoader()
        case .notTester:
            showAlert(text: String(localized: "error_notTester"))
            self.view.removeBluerLoader()
        case .blocked:
            showAlert(text: String(localized: "error_blocked"))
            self.view.removeBluerLoader()
        }

    }

    func loginViewPresenter(_ reposViewModel: LoginViewPresenter, isLoading: Bool) {
        if isLoading { self.view.showBlurLoader() } else { self.view.removeBluerLoader() }
    }

}
