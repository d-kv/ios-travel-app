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

    let signOutButton = DI.shared.getInterfaceExt().lightGreyButton(title: String(localized: "settings_leave"), color: UIColor(named: "LightGrayColor") ?? .white)

    let resetRecommendButton = DI.shared.getInterfaceExt().lightGreyButton(title: String(localized: "settings_recommendations"), color: UIColor(named: "LightGrayColor") ?? .white)
    let adminButton = DI.shared.getInterfaceExt().lightGreyButton(title: String(localized: "settings_admin"), color: UIColor(named: "LightGrayColor") ?? .white)

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
        let cache = CacheImpl.shared
        userName.text = (cache.getPreferences(forKey: "lastName")) + " " + (cache.getPreferences(forKey: "firstName"))
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

        if cache.getPreferencesBool(forKey: "isAdmin") {
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
            userName.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]

        achievementsView.translatesAutoresizingMaskIntoConstraints = false
        let achievementsViewConstraints = [
            achievementsView.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 10),
            achievementsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            achievementsView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25),
            achievementsView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25),
            achievementsView.heightAnchor.constraint(equalToConstant: 180)
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

        let constraintsArray = [userImageConstraints, userNameConstraints, achievementsViewConstraints, signOutButtonConstraints, resetRecommendButtonConstraints, adminButtonConstraints].flatMap {$0}
        NSLayoutConstraint.activate(constraintsArray)
    }

    // MARK: - Button actions

    @objc func signOutTap() {

        let alert = UIAlertController(title: String(localized: "confirmation"), message: String(localized: "sign_out"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: String(localized: "yes"), style: .destructive, handler: { _ in
            DI.shared.getSettingsViewPresenter().signOut()
        }))
        alert.addAction(UIAlertAction(title: String(localized: "no"), style: .default))
        self.present(alert, animated: true, completion: nil)

    }

    @objc func adminTap() {
        var host = ""
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
            let keys = NSDictionary(contentsOfFile: path) ?? NSDictionary()
            host = keys["HOST"] as? String ?? ""
        }
        if let url = URL(string: host + "/admin/") {
            UIApplication.shared.open(url)
        }

    }

    // MARK: - Custom Views
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
    let ninthImage = UIButton()
    
    private func preCreation() {
        zeroImage.setImage(UIImage(named: "bottleImage0")?.withTintColor(UIColor(named: "YellowColor") ?? .yellow), for: .normal)
        zeroImage.addTarget(self, action: #selector(achievementTap), for: .touchUpInside)
        zeroImage.tag = 0
        zeroImage.isHidden = true

        firstImage.setImage(UIImage(named: "michleinAImage1")?.withTintColor(UIColor(named: "YellowColor") ?? .yellow), for: .normal)
        firstImage.addTarget(self, action: #selector(achievementTap), for: .touchUpInside)
        firstImage.tag = 1
        firstImage.isHidden = true

        secondImage.setImage(UIImage(named: "gidImage2")?.withTintColor(UIColor(named: "YellowColor") ?? .yellow), for: .normal)
        secondImage.addTarget(self, action: #selector(achievementTap), for: .touchUpInside)
        secondImage.tag = 2
        secondImage.isHidden = true

        thirdImage.setImage(UIImage(named: "greenImage3")?.withTintColor(UIColor(named: "YellowColor") ?? .yellow), for: .normal)
        thirdImage.addTarget(self, action: #selector(achievementTap), for: .touchUpInside)
        thirdImage.tag = 3
        thirdImage.isHidden = true

        fourthImage.setImage(UIImage(named: "pdrImage4")?.withTintColor(UIColor(named: "YellowColor") ?? .yellow), for: .normal)
        fourthImage.addTarget(self, action: #selector(achievementTap), for: .touchUpInside)
        fourthImage.tag = 4
        fourthImage.isHidden = true

        fivthImage.setImage(UIImage(named: "hrImage5")?.withTintColor(UIColor(named: "YellowColor") ?? .yellow), for: .normal)
        fivthImage.addTarget(self, action: #selector(achievementTap), for: .touchUpInside)
        fivthImage.tag = 5
        fivthImage.isHidden = true

        sixthImage.setImage(UIImage(named: "armanImage6")?.withTintColor(UIColor(named: "YellowColor") ?? .yellow), for: .normal)
        sixthImage.addTarget(self, action: #selector(achievementTap), for: .touchUpInside)
        sixthImage.tag = 6
        sixthImage.isHidden = true

        seventhImage.setImage(UIImage(named: "decisionImage7")?.withTintColor(UIColor(named: "YellowColor") ?? .yellow), for: .normal)
        seventhImage.addTarget(self, action: #selector(achievementTap), for: .touchUpInside)
        seventhImage.tag = 7
        seventhImage.isHidden = true

        eightthImage.setImage(UIImage(named: "testerImage8")?.withTintColor(UIColor(named: "YellowColor") ?? .yellow), for: .normal)
        eightthImage.addTarget(self, action: #selector(achievementTap), for: .touchUpInside)
        eightthImage.tag = 8
        eightthImage.isHidden = true

        ninthImage.setImage(UIImage(named: "deusVultImage9")?.withTintColor(UIColor(named: "YellowColor") ?? .yellow), for: .normal)
        ninthImage.addTarget(self, action: #selector(achievementTap), for: .touchUpInside)
        ninthImage.tag = 9
        ninthImage.isHidden = true
    }
    
    private func textViewPreCreation() {
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
    }
    
    private func getFirstConstraints() -> [[NSLayoutConstraint]] {
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
            thirdImage.leftAnchor.constraint(equalTo: secondImage.rightAnchor, constant: 15)
        ]

        fourthImage.translatesAutoresizingMaskIntoConstraints = false
        let fourthImageConstraints = [
            fourthImage.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 5),
            fourthImage.heightAnchor.constraint(equalToConstant: 50),
            fourthImage.widthAnchor.constraint(equalToConstant: 50),
            fourthImage.leftAnchor.constraint(equalTo: thirdImage.rightAnchor, constant: 15)
        ]
        
        return [textViewConstraints, zeroImageConstraints, firstImageConstraints, secondImageConstraints, thirdImageConstraints, fourthImageConstraints]
    }
    
    private func getSecondConstraints() -> [[NSLayoutConstraint]] {
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

        ninthImage.translatesAutoresizingMaskIntoConstraints = false
        let ninthImageConstraints = [
            ninthImage.bottomAnchor.constraint(equalTo: achievementsView.bottomAnchor, constant: -10),
            ninthImage.heightAnchor.constraint(equalToConstant: 50),
            ninthImage.widthAnchor.constraint(equalToConstant: 50),
            ninthImage.leftAnchor.constraint(equalTo: eightthImage.rightAnchor, constant: 15)
        ]
        
        return [fivthImageConstraints, sixthImageConstraints, seventhImageConstraints, eightthImageConstraints, ninthImageConstraints]
    }

    func addTo_achievementsView() {
        preCreation()
        textViewPreCreation()

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
        achievementsView.addSubview(ninthImage)

        NSLayoutConstraint.activate(getFirstConstraints().flatMap {$0})
        NSLayoutConstraint.activate(getSecondConstraints().flatMap {$0})

        let userA = UserDefaults.standard.string(forKey: "achievements") ?? ""
        for i in userA {
            if i == "0" { zeroImage.isHidden = false }
            achievementsView.viewWithTag(Int(String(i)) ?? 1)?.isHidden = false
        }
    }

    @objc func achievementTap(_ sender: UIButton) {
        let enums = achievementsEnums.self
        switch sender.tag {
        case enums.good.rawValue:
            showAlert(title: String(localized: "achievements_good_title"), message: String(localized: "achievements_good_text"))
        case enums.inspector.rawValue:
            showAlert(title: String(localized: "achievements_inspector_title"), message: String(localized: "achievements_inspector_text"))
        case enums.guide.rawValue:
            showAlert(title: String(localized: "achievements_guide_title"), message: String(localized: "achievements_guide_text"))
        case enums.green.rawValue:
            showAlert(title: String(localized: "achievements_green_title"), message: String(localized: "achievements_green_text"))
        case enums.star.rawValue:
            showAlert(title: String(localized: "achievements_star_title"), message: String(localized: "achievements_star_text"))
        case enums.hr.rawValue:
            showAlert(title: String(localized: "achievements_hr_title"), message: String(localized: "achievements_hr_text"))
        case enums.way.rawValue:
            showAlert(title: String(localized: "achievements_way_title"), message: String(localized: "achievements_way_text"))
        case enums.question.rawValue:
            showAlert(title: String(localized: "achievements_question_title"), message: String(localized: "achievements_question_text"))
        case enums.money.rawValue:
            showAlert(title: String(localized: "achievements_money_title"), message: String(localized: "achievements_money_text"))
        case enums.deusvult.rawValue:
            showAlert(title: String(localized: "achievements_deusvult_title"), message: String(localized: "achievements_deusvult_text"))
        default: break
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        self.present(alert, animated: true, completion: nil)
    }

    private enum achievementsEnums: Int {
        case good = 0
        case inspector = 1
        case guide = 2
        case green = 3
        case star = 4
        case hr = 5
        case way = 6
        case question = 7
        case money = 8
        case deusvult = 9
    }

}
