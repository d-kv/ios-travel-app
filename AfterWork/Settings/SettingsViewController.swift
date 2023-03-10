//
//  SettingsViewController.swift
//  Tinkoff Travel
//
//  Created by Евгений Парфененков on 02.03.2023.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Creation Views
    
    let userImage = UIImageView(image: UIImage(named: "userImage"))
    let userName = UITextView()
    
    let achievementsView = UIView()
    
    let signOutButton = UIButton()
    let resetRecommendButton = UIButton()
    let adminButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.text = "Парфененков Евгений"
        userName.contentInsetAdjustmentBehavior = .automatic
        userName.center = self.view.center
        userName.textAlignment = NSTextAlignment.justified
        userName.textColor = .white
        userName.backgroundColor = .clear
        userName.font = UIFont(name: "Helvetica Neue Bold", size: 28)
        userName.adjustsFontForContentSizeCategory = false
        userName.isEditable = false
        userName.sizeToFit()
        userName.isScrollEnabled = false
        userName.isSelectable = false
        
        achievementsView.backgroundColor = .black
        achievementsView.layer.cornerRadius = 23
        addTo_achievementsView()
        
        signOutButton.setTitle("Выйти из аккаунта", for: .normal)
        signOutButton.backgroundColor = .red
        signOutButton.layer.cornerRadius = 23
        signOutButton.setTitleColor(.black, for: .normal)
        signOutButton.titleLabel?.font = UIFont(name: "Helvetica Neue Bold", size: 24)
        signOutButton.addTarget(self, action: #selector(signOutTap), for: .touchUpInside)
        
        resetRecommendButton.setTitle("Cбросить рекомендации", for: .normal)
        resetRecommendButton.backgroundColor = UIColor(named: "YellowColor")
        resetRecommendButton.layer.cornerRadius = 23
        resetRecommendButton.setTitleColor(.black, for: .normal)
        resetRecommendButton.titleLabel?.font = UIFont(name: "Helvetica Neue Bold", size: 24)
        
        adminButton.setTitle("Админ-панель", for: .normal)
        adminButton.backgroundColor = .black
        adminButton.layer.cornerRadius = 23
        adminButton.setTitleColor(UIColor(named: "YellowColor"), for: .normal)
        adminButton.titleLabel?.font = UIFont(name: "Helvetica Neue Bold", size: 26)
        
        setUpConstraints()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = UIColor(named: "GreyColor")
    }
    
    // MARK: - Constraints
    
    func setUpConstraints() {
        
        userImage.translatesAutoresizingMaskIntoConstraints = false
        let userImageConstraints = [
            userImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 35),
            userImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userImage.widthAnchor.constraint(equalToConstant: 130),
            userImage.heightAnchor.constraint(equalToConstant: 130)
        ]
        
        userName.translatesAutoresizingMaskIntoConstraints = false
        let userNameConstraints = [
            userName.topAnchor.constraint(equalTo: userImage.bottomAnchor, constant: 10),
            userName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ]
        
        achievementsView.translatesAutoresizingMaskIntoConstraints = false
        let achievementsViewConstraints = [
            achievementsView.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 10),
            achievementsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            achievementsView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25),
            achievementsView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25),
            achievementsView.heightAnchor.constraint(equalToConstant: 180),
        ]
        
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        let signOutButtonConstraints = [
            signOutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -35),
            signOutButton.leftAnchor.constraint(equalTo: achievementsView.leftAnchor),
            signOutButton.rightAnchor.constraint(equalTo: achievementsView.rightAnchor),
            signOutButton.heightAnchor.constraint(equalToConstant: 70)
        ]
        
        resetRecommendButton.translatesAutoresizingMaskIntoConstraints = false
        let resetRecommendButtonConstraints = [
            resetRecommendButton.bottomAnchor.constraint(equalTo: signOutButton.topAnchor, constant: -20),
            resetRecommendButton.leftAnchor.constraint(equalTo: achievementsView.leftAnchor),
            resetRecommendButton.rightAnchor.constraint(equalTo: achievementsView.rightAnchor),
            resetRecommendButton.heightAnchor.constraint(equalToConstant: 70)
        ]
        
        adminButton.translatesAutoresizingMaskIntoConstraints = false
        let adminButtonConstraints = [
            adminButton.bottomAnchor.constraint(equalTo: resetRecommendButton.topAnchor, constant: -20),
            adminButton.leftAnchor.constraint(equalTo: achievementsView.leftAnchor),
            adminButton.rightAnchor.constraint(equalTo: achievementsView.rightAnchor),
            adminButton.heightAnchor.constraint(equalToConstant: 70)
        ]
        
        view.addSubview(userImage)
        view.addSubview(userName)
        
        view.addSubview(achievementsView)
        
        view.addSubview(signOutButton)
        view.addSubview(resetRecommendButton)
        view.addSubview(adminButton)
        
        let constraintsArray = [userImageConstraints, userNameConstraints, achievementsViewConstraints, signOutButtonConstraints, resetRecommendButtonConstraints, adminButtonConstraints].flatMap{$0}
        NSLayoutConstraint.activate(constraintsArray)
    }
    
    // MARK: - Button actions
    
    @objc func signOutTap() {
        //SettingsViewPresenter.signOut()
        
        let alert = UIAlertController(title: "Подтверждение", message: "Выйти из приложения?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .destructive, handler: { action in
            SettingsViewPresenter.signOut()
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .default))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Custom Views
    
    func addTo_achievementsView() {
        let textView = UITextView()
        let firstImage = UIImageView(image: UIImage(named: "bottleImage"))
        
        textView.text = "Достижения"
        textView.contentInsetAdjustmentBehavior = .automatic
        textView.center = self.view.center
        textView.textAlignment = NSTextAlignment.justified
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.font = UIFont(name: "Helvetica Neue Bold", size: 24)
        textView.adjustsFontForContentSizeCategory = false
        textView.isEditable = false
        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.isSelectable = false
        
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        let textViewConstraints = [
            textView.topAnchor.constraint(equalTo: achievementsView.topAnchor, constant: 5),
            textView.centerXAnchor.constraint(equalTo: achievementsView.centerXAnchor)
        ]
        
        firstImage.translatesAutoresizingMaskIntoConstraints = false
        let firstImageConstraints = [
            firstImage.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 5),
            firstImage.heightAnchor.constraint(equalToConstant: 40),
            firstImage.widthAnchor.constraint(equalToConstant: 40),
            firstImage.centerXAnchor.constraint(equalTo: achievementsView.centerXAnchor)
        ]
        
        achievementsView.addSubview(textView)
        NSLayoutConstraint.activate(textViewConstraints)
        
        achievementsView.addSubview(firstImage)
        NSLayoutConstraint.activate(firstImageConstraints)
    }
    
}
