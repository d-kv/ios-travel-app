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
    
    let signOutButton = DI.shared.getInterfaceExt().lightGreyButton(title: String(localized: "settings_leave"), color: UIColor(named: "LightGrayColor")!)
    
    let resetRecommendButton = DI.shared.getInterfaceExt().lightGreyButton(title: String(localized: "settings_recomendations"), color: UIColor(named: "LightGrayColor")!)
    let adminButton = DI.shared.getInterfaceExt().lightGreyButton(title: String(localized: "settings_admin"), color: UIColor(named: "LightGrayColor")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        create()
        setUpConstraints()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = UIColor(named: "GreyColor")
    }
    
    // MARK: - Constraints
    
    func create() {
        let preferences = UserDefaults.standard
        userName.text = preferences.string(forKey: "lastName")! + " " + preferences.string(forKey: "firstName")!
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
        
        achievementsView.backgroundColor = UIColor(named: "LightGrayColor")
        achievementsView.layer.cornerRadius = 23
        addTo_achievementsView()
        
        signOutButton.setTitleColor(.red, for: .normal)
        signOutButton.addTarget(self, action: #selector(signOutTap), for: .touchUpInside)
        
        if preferences.bool(forKey: "isAdmin") {
            adminButton.addTarget(self, action: #selector(adminTap), for: .touchUpInside)
        } else {
            adminButton.isHidden = true
        }
    }
    
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
            signOutButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        resetRecommendButton.translatesAutoresizingMaskIntoConstraints = false
        let resetRecommendButtonConstraints = [
            resetRecommendButton.bottomAnchor.constraint(equalTo: signOutButton.topAnchor, constant: -20),
            resetRecommendButton.leftAnchor.constraint(equalTo: achievementsView.leftAnchor),
            resetRecommendButton.rightAnchor.constraint(equalTo: achievementsView.rightAnchor),
            resetRecommendButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        adminButton.translatesAutoresizingMaskIntoConstraints = false
        let adminButtonConstraints = [
            adminButton.bottomAnchor.constraint(equalTo: resetRecommendButton.topAnchor, constant: -20),
            adminButton.leftAnchor.constraint(equalTo: achievementsView.leftAnchor),
            adminButton.rightAnchor.constraint(equalTo: achievementsView.rightAnchor),
            adminButton.heightAnchor.constraint(equalToConstant: 50)
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
            DI.shared.getSettingsViewPresenter().signOut()
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .default))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func adminTap() {
        
        if let url = URL(string: "http://82.146.33.253:8000/admin/") {
            UIApplication.shared.open(url)
        }
        
    }
    
    // MARK: - Custom Views
    
    func addTo_achievementsView() {
        let textView = UITextView()
        let zeroImage = UIButton()
        let firstImage = UIButton()
        let secondImage = UIButton()
        let thirdImage = UIButton()
        let fourthImage = UIButton()
        let fivthImage = UIButton()
        let sixthImage = UIButton()
        let seventhImage = UIButton()
        let eightthImage = UIButton()
        let ninethImage = UIButton()
        
        zeroImage.setImage(UIImage(named: "bottleImage0")?.withTintColor(UIColor(named: "YellowColor")!), for: .normal)
        zeroImage.addTarget(self, action: #selector(achievementTap), for: .touchUpInside)
        zeroImage.tag = 0
        zeroImage.isHidden = true
        
        firstImage.setImage(UIImage(named: "michleinAImage1")?.withTintColor(UIColor(named: "YellowColor")!), for: .normal)
        firstImage.addTarget(self, action: #selector(achievementTap), for: .touchUpInside)
        firstImage.tag = 1
        firstImage.isHidden = true
        
        secondImage.setImage(UIImage(named: "gidImage2")?.withTintColor(UIColor(named: "YellowColor")!), for: .normal)
        secondImage.addTarget(self, action: #selector(achievementTap), for: .touchUpInside)
        secondImage.tag = 2
        secondImage.isHidden = true
        
        thirdImage.setImage(UIImage(named: "greenImage3")?.withTintColor(UIColor(named: "YellowColor")!), for: .normal)
        thirdImage.addTarget(self, action: #selector(achievementTap), for: .touchUpInside)
        thirdImage.tag = 3
        thirdImage.isHidden = true
        
        fourthImage.setImage(UIImage(named: "pdrImage4")?.withTintColor(UIColor(named: "YellowColor")!), for: .normal)
        fourthImage.addTarget(self, action: #selector(achievementTap), for: .touchUpInside)
        fourthImage.tag = 4
        fourthImage.isHidden = true
        
        fivthImage.setImage(UIImage(named: "hrImage5")?.withTintColor(UIColor(named: "YellowColor")!), for: .normal)
        fivthImage.addTarget(self, action: #selector(achievementTap), for: .touchUpInside)
        fivthImage.tag = 5
        fivthImage.isHidden = true
        
        sixthImage.setImage(UIImage(named: "armanImage6")?.withTintColor(UIColor(named: "YellowColor")!), for: .normal)
        sixthImage.addTarget(self, action: #selector(achievementTap), for: .touchUpInside)
        sixthImage.tag = 6
        sixthImage.isHidden = true
        
        seventhImage.setImage(UIImage(named: "desicionImage7")?.withTintColor(UIColor(named: "YellowColor")!), for: .normal)
        seventhImage.addTarget(self, action: #selector(achievementTap), for: .touchUpInside)
        seventhImage.tag = 7
        seventhImage.isHidden = true
        
        eightthImage.setImage(UIImage(named: "testerImage8")?.withTintColor(UIColor(named: "YellowColor")!), for: .normal)
        eightthImage.addTarget(self, action: #selector(achievementTap), for: .touchUpInside)
        eightthImage.tag = 8
        eightthImage.isHidden = true
        
        ninethImage.setImage(UIImage(named: "deusVultImage9")?.withTintColor(UIColor(named: "YellowColor")!), for: .normal)
        ninethImage.addTarget(self, action: #selector(achievementTap), for: .touchUpInside)
        ninethImage.tag = 9
        ninethImage.isHidden = true
        
        textView.text = String(localized: "settings_achievements")
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
        
        zeroImage.translatesAutoresizingMaskIntoConstraints = false
        let zeroImageConstraints = [
            zeroImage.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 5),
            zeroImage.heightAnchor.constraint(equalToConstant: 50),
            zeroImage.widthAnchor.constraint(equalToConstant: 50),
            zeroImage.rightAnchor.constraint(equalTo: firstImage.leftAnchor, constant: -15)
        ]
        
        firstImage.translatesAutoresizingMaskIntoConstraints = false
        let firstImageConstraints = [
            firstImage.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 5),
            firstImage.heightAnchor.constraint(equalToConstant: 50),
            firstImage.widthAnchor.constraint(equalToConstant: 50),
            firstImage.rightAnchor.constraint(equalTo: secondImage.leftAnchor, constant: -15)
        ]
        
        secondImage.translatesAutoresizingMaskIntoConstraints = false
        let secondImageConstraints = [
            secondImage.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 5),
            secondImage.heightAnchor.constraint(equalToConstant: 50),
            secondImage.widthAnchor.constraint(equalToConstant: 50),
            secondImage.centerXAnchor.constraint(equalTo: achievementsView.centerXAnchor)
        ]
        
        thirdImage.translatesAutoresizingMaskIntoConstraints = false
        let thirdImageConstraints = [
            thirdImage.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 5),
            thirdImage.heightAnchor.constraint(equalToConstant: 50),
            thirdImage.widthAnchor.constraint(equalToConstant: 50),
            //thirdImage.rightAnchor.constraint(equalTo: secondImage.rightAnchor, constant: 20),
            thirdImage.leftAnchor.constraint(equalTo: secondImage.rightAnchor, constant: 15)
        ]
        
        fourthImage.translatesAutoresizingMaskIntoConstraints = false
        let fourthImageConstraints = [
            fourthImage.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 5),
            fourthImage.heightAnchor.constraint(equalToConstant: 50),
            fourthImage.widthAnchor.constraint(equalToConstant: 50),
            fourthImage.leftAnchor.constraint(equalTo: thirdImage.rightAnchor, constant: 15)
        ]
        
        fivthImage.translatesAutoresizingMaskIntoConstraints = false
        let fivthImageConstraints = [
            fivthImage.bottomAnchor.constraint(equalTo: achievementsView.bottomAnchor, constant: -10),
            fivthImage.heightAnchor.constraint(equalToConstant: 50),
            fivthImage.widthAnchor.constraint(equalToConstant: 50),
            fivthImage.rightAnchor.constraint(equalTo: sixthImage.leftAnchor, constant: -15)
        ]
        
        sixthImage.translatesAutoresizingMaskIntoConstraints = false
        let sixthImageConstraints = [
            sixthImage.bottomAnchor.constraint(equalTo: achievementsView.bottomAnchor, constant: -10),
            sixthImage.heightAnchor.constraint(equalToConstant: 50),
            sixthImage.widthAnchor.constraint(equalToConstant: 50),
            sixthImage.rightAnchor.constraint(equalTo: seventhImage.leftAnchor, constant: -15)
        ]
        
        seventhImage.translatesAutoresizingMaskIntoConstraints = false
        let seventhImageConstraints = [
            seventhImage.bottomAnchor.constraint(equalTo: achievementsView.bottomAnchor, constant: -10),
            seventhImage.heightAnchor.constraint(equalToConstant: 50),
            seventhImage.widthAnchor.constraint(equalToConstant: 50),
            seventhImage.centerXAnchor.constraint(equalTo: achievementsView.centerXAnchor)
        ]
        
        eightthImage.translatesAutoresizingMaskIntoConstraints = false
        let eightthImageConstraints = [
            eightthImage.bottomAnchor.constraint(equalTo: achievementsView.bottomAnchor, constant: -10),
            eightthImage.heightAnchor.constraint(equalToConstant: 50),
            eightthImage.widthAnchor.constraint(equalToConstant: 50),
            eightthImage.leftAnchor.constraint(equalTo: seventhImage.rightAnchor, constant: 15)
        ]
        
        ninethImage.translatesAutoresizingMaskIntoConstraints = false
        let ninethImageConstraints = [
            ninethImage.bottomAnchor.constraint(equalTo: achievementsView.bottomAnchor, constant: -10),
            ninethImage.heightAnchor.constraint(equalToConstant: 50),
            ninethImage.widthAnchor.constraint(equalToConstant: 50),
            ninethImage.leftAnchor.constraint(equalTo: eightthImage.rightAnchor, constant: 15)
        ]
        
        achievementsView.addSubview(textView)
        achievementsView.addSubview(zeroImage)
        achievementsView.addSubview(firstImage)
        achievementsView.addSubview(secondImage)
        achievementsView.addSubview(thirdImage)
        achievementsView.addSubview(fourthImage)
        achievementsView.addSubview(fivthImage)
        achievementsView.addSubview(sixthImage)
        achievementsView.addSubview(seventhImage)
        achievementsView.addSubview(eightthImage)
        achievementsView.addSubview(ninethImage)
        
        let constraintsArray = [textViewConstraints, zeroImageConstraints, firstImageConstraints, secondImageConstraints, thirdImageConstraints, fourthImageConstraints, fivthImageConstraints, sixthImageConstraints, seventhImageConstraints, eightthImageConstraints, ninethImageConstraints].flatMap{$0}
        NSLayoutConstraint.activate(constraintsArray)
        
        let userA = UserDefaults.standard.string(forKey: "achievements")!
        for i in userA {
            if i == "0" { zeroImage.isHidden = false }
            achievementsView.viewWithTag(Int(String(i))!)?.isHidden = false
        }
    }
    
    @objc func achievementTap(_ sender: UIButton) {
        print("sender:", sender.tag)
        switch sender.tag {
        case 0:
            showAlert(title: "Хороший отдых", message: "из-за трясущихся рук промахиваетесь по кнопкам")
        case 1:
            showAlert(title: "Инспектор Мишлен", message: "заслуженный оценщик заведений")
        case 2:
            showAlert(title: "Гид", message: "провести за собой группу людей")
        case 3:
            showAlert(title: "Истинный зеленый", message: "большинство отзывов негативные")
        case 4:
            showAlert(title: "*****", message: "скачивать приложение только по необходимости или ставить негативную оценку")
        case 5:
            showAlert(title: "HR", message: "просто и понятно - админ или разработчик")
        case 6:
            showAlert(title: "Вайвай", message: "стать премиум пользователем")
        case 7:
            showAlert(title: "Сама неопределенность", message: "иметь трудности с выбором")
        case 8:
            showAlert(title: "Нахлебник", message: "участвовал в тестировании приложения")
        case 9:
            showAlert(title: "Deus Vult", message: "не раскрывается")
        default: break
            //do nothing
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
}
