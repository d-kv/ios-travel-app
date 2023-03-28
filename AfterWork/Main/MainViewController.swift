//
//  MainViewController.swift
//  Tinkoff Travel
//
//  Created by Евгений Парфененков on 02.03.2023.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    
    let userImage = UIButton()
    let userName = UITextView()
    let searchBar = UISearchBar()
    
    let bigRecommend = UIView()
    let centerRecommend = UIView()
    let leftRecommend = UIView()
    let rightRecommend = UIView()
    let personalRecommend = UIView()
    
    let checkAllButton = UIButton()
    
    let mainViewPresenter = DI.shared.getMainViewPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        self.mainViewPresenter.delegate = self
                
        creation()
        setUpConstraints()
        
        mainViewPresenter.enteredApp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = .black
    }
    
    @objc private func userImageTap() {
        mainViewPresenter.openSettings()
    }
    
    @objc private func checkAllButtonTap() {
        self.checkAllButton.showAnimation {}
        self.mainViewPresenter.goToMap()
    }
    
    @objc private func bigRecommendTap() {
        self.bigRecommend.showAnimation {}
        mainViewPresenter.goToCards()
    }
    
    @objc private func centerRecommendTap() {
        self.centerRecommend.showAnimation {}
        mainViewPresenter.goToCards()
    }
    
    @objc private func leftRecommendTap() {
        self.leftRecommend.showAnimation {}
        mainViewPresenter.goToCards()
    }
    
    @objc private func rightRecommendTap() {
        self.rightRecommend.showAnimation {}
        mainViewPresenter.goToCards()
    }
    
    @objc private func personalRecommendTap() {
        self.personalRecommend.showAnimation {}
        mainViewPresenter.goToCards()
    }
    
    // MARK: - Contraints
    
    func creation() {
        userImage.setImage(UIImage(named: "userImage"), for: .normal)
        userImage.addTarget(self, action: #selector(userImageTap), for: .touchUpInside)
        
        userName.text = "Евгений,\n" + String(localized: "main_top")
        userName.contentInsetAdjustmentBehavior = .automatic
        userName.center = self.view.center
        userName.textAlignment = NSTextAlignment.justified
        userName.textColor = .white
        userName.backgroundColor = .clear
        userName.font = UIFont(name: "Helvetica Neue Bold", size: 30)
        userName.adjustsFontForContentSizeCategory = false
        userName.isEditable = false
        userName.sizeToFit()
        userName.isScrollEnabled = false
        userName.isSelectable = false
        
        searchBar.placeholder = String(localized: "main_search")
        searchBar.barTintColor = .clear
        
        bigRecommend.backgroundColor = UIColor(named: "GreyColor")
        bigRecommend.layer.cornerRadius = 23
        addto_bigRecommend()
        
        centerRecommend.backgroundColor = UIColor(named: "GreyColor")
        centerRecommend.layer.cornerRadius = 23
        addto_centerRecommend()
        
        leftRecommend.backgroundColor = UIColor(named: "GreyColor")
        leftRecommend.layer.cornerRadius = 23
        addto_leftRecommend()
        
        rightRecommend.backgroundColor = UIColor(named: "GreyColor")
        rightRecommend.layer.cornerRadius = 23
        addto_rightRecommend()
        
        personalRecommend.backgroundColor = UIColor(named: "GreyColor")
        personalRecommend.layer.cornerRadius = 23
        addto_personalRecommend()
        
        personalRecommend.isUserInteractionEnabled = true
        bigRecommend.isUserInteractionEnabled = true
        leftRecommend.isUserInteractionEnabled = true
        centerRecommend.isUserInteractionEnabled = true
        rightRecommend.isUserInteractionEnabled = true
        
        let gesturePersonal:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(personalRecommendTap))
        gesturePersonal.numberOfTapsRequired = 1
        let gestureBig:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(bigRecommendTap))
        gestureBig.numberOfTapsRequired = 1
        let gestureLeft:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(leftRecommendTap))
        gestureLeft.numberOfTapsRequired = 1
        let gestureCenter:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(centerRecommendTap))
        gestureCenter.numberOfTapsRequired = 1
        let gestureRight:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(rightRecommendTap))
        gestureRight.numberOfTapsRequired = 1
        
        personalRecommend.addGestureRecognizer(gesturePersonal)
        bigRecommend.addGestureRecognizer(gestureBig)
        leftRecommend.addGestureRecognizer(gestureLeft)
        centerRecommend.addGestureRecognizer(gestureCenter)
        rightRecommend.addGestureRecognizer(gestureRight)
        
        checkAllButton.setTitle(String(localized: "main_all"), for: .normal)
        checkAllButton.backgroundColor = UIColor(named: "YellowColor")
        checkAllButton.layer.cornerRadius = 23
        checkAllButton.setTitleColor(.black, for: .normal)
        checkAllButton.titleLabel?.font = UIFont(name: "Helvetica Neue Bold", size: 22)
        checkAllButton.addTarget(self, action: #selector(checkAllButtonTap), for: .touchUpInside)
    }
    
    func setUpConstraints() {
        
        userImage.translatesAutoresizingMaskIntoConstraints = false
        let userImageConstraints = [
            userImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            userImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            userImage.widthAnchor.constraint(equalToConstant: 70),
            userImage.heightAnchor.constraint(equalToConstant: 70)
        ]
        
        userName.translatesAutoresizingMaskIntoConstraints = false
        let userNameConstraints = [
            userName.topAnchor.constraint(equalTo: userImage.topAnchor, constant: -10),
            userName.leftAnchor.constraint(equalTo: userImage.rightAnchor, constant: 10),
            userName.widthAnchor.constraint(equalToConstant: 300),
            userName.heightAnchor.constraint(equalTo: userImage.heightAnchor, constant: 15)
        ]
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        let searchBarConstraints = [
            searchBar.topAnchor.constraint(equalTo: userImage.bottomAnchor, constant: 20),
            searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor)
        ]
        
        bigRecommend.translatesAutoresizingMaskIntoConstraints = false
        let bigRecommendConstraints = [
            bigRecommend.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 15),
            bigRecommend.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bigRecommend.leftAnchor.constraint(equalTo: searchBar.leftAnchor, constant: 10),
            bigRecommend.rightAnchor.constraint(equalTo: searchBar.rightAnchor, constant: -10),
            bigRecommend.heightAnchor.constraint(equalToConstant: 110),
        ]
        
        centerRecommend.translatesAutoresizingMaskIntoConstraints = false
        let centerRecommendConstraints = [
            centerRecommend.topAnchor.constraint(equalTo: bigRecommend.bottomAnchor, constant: 20),
            centerRecommend.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerRecommend.heightAnchor.constraint(equalToConstant: 110),
            centerRecommend.widthAnchor.constraint(equalToConstant: 110)
        ]
        
        leftRecommend.translatesAutoresizingMaskIntoConstraints = false
        let leftRecommendConstraints = [
            leftRecommend.topAnchor.constraint(equalTo: bigRecommend.bottomAnchor, constant: 20),
            leftRecommend.leftAnchor.constraint(equalTo: searchBar.leftAnchor, constant: 10),
            leftRecommend.rightAnchor.constraint(equalTo: centerRecommend.leftAnchor, constant: -20),
            leftRecommend.heightAnchor.constraint(equalToConstant: 110),
        ]
        
        rightRecommend.translatesAutoresizingMaskIntoConstraints = false
        let rightRecommendConstraints = [
            rightRecommend.topAnchor.constraint(equalTo: bigRecommend.bottomAnchor, constant: 20),
            rightRecommend.leftAnchor.constraint(equalTo: centerRecommend.rightAnchor, constant: 20),
            rightRecommend.rightAnchor.constraint(equalTo: searchBar.rightAnchor, constant: -10),
            rightRecommend.heightAnchor.constraint(equalToConstant: 110),
        ]
        
        personalRecommend.translatesAutoresizingMaskIntoConstraints = false
        let personalRecommendConstraints = [
            personalRecommend.topAnchor.constraint(equalTo: centerRecommend.bottomAnchor, constant: 20),
            personalRecommend.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            personalRecommend.leftAnchor.constraint(equalTo: searchBar.leftAnchor, constant: 10),
            personalRecommend.rightAnchor.constraint(equalTo: searchBar.rightAnchor, constant: -10),
            personalRecommend.heightAnchor.constraint(equalToConstant: 200),
        ]
        
        checkAllButton.translatesAutoresizingMaskIntoConstraints = false
        let checkAllButtonConstraints = [
            checkAllButton.topAnchor.constraint(equalTo: personalRecommend.bottomAnchor, constant: 20),
            checkAllButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkAllButton.leftAnchor.constraint(equalTo: searchBar.leftAnchor, constant: 10),
            checkAllButton.rightAnchor.constraint(equalTo: searchBar.rightAnchor, constant: -10),
            checkAllButton.heightAnchor.constraint(equalToConstant: 70),
        ]
        
        view.addSubview(userImage)
        view.addSubview(userName)
        view.addSubview(searchBar)
        
        view.addSubview(bigRecommend)
        view.addSubview(centerRecommend)
        view.addSubview(leftRecommend)
        view.addSubview(rightRecommend)
        view.addSubview(personalRecommend)
        
        view.addSubview(checkAllButton)
        
        let constraintsArray = [userImageConstraints, userNameConstraints, searchBarConstraints, bigRecommendConstraints, centerRecommendConstraints, leftRecommendConstraints, rightRecommendConstraints, personalRecommendConstraints, checkAllButtonConstraints].flatMap{$0}
        NSLayoutConstraint.activate(constraintsArray)
        
    }
    
    // MARK: - Content on Custom Views
    
    func addto_bigRecommend() {
        let bigText = DI.shared.getInterfaceExt().frameTextView(text: String(localized: "main_cafe_big"), font: .boldSystemFont(ofSize: 24), lineHeightMultiple: 0.6)
        let smallText = DI.shared.getInterfaceExt().frameTextView(text: String(localized: "main_cafe_small"), font: .systemFont(ofSize: 14), lineHeightMultiple: 0.6)
        let imageView = UIImageView(image: UIImage(named: "cupImage"))
        
        bigText.translatesAutoresizingMaskIntoConstraints = false
        let bigTextConstraints = [
            bigText.topAnchor.constraint(equalTo: bigRecommend.topAnchor, constant: 15),
            bigText.leftAnchor.constraint(equalTo: bigRecommend.leftAnchor, constant: 10),
            bigText.widthAnchor.constraint(equalToConstant: 100),
            bigText.heightAnchor.constraint(equalToConstant: 30)
        ]
        
        smallText.translatesAutoresizingMaskIntoConstraints = false
        let smallTextConstraints = [
            smallText.topAnchor.constraint(equalTo: bigText.bottomAnchor, constant: -5),
            smallText.leftAnchor.constraint(equalTo: bigRecommend.leftAnchor, constant: 10),
            smallText.widthAnchor.constraint(equalToConstant: 400),
            smallText.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let imageViewConstraints = [
            imageView.topAnchor.constraint(equalTo: bigRecommend.topAnchor, constant: 15),
            imageView.bottomAnchor.constraint(equalTo: bigRecommend.bottomAnchor, constant: -15),
            imageView.rightAnchor.constraint(equalTo: bigRecommend.rightAnchor, constant: -20),
            imageView.widthAnchor.constraint(equalToConstant: 80),
        ]
        
        bigRecommend.addSubview(bigText)
        bigRecommend.addSubview(smallText)
        bigRecommend.addSubview(imageView)
        
        let constraintsArray = [bigTextConstraints, smallTextConstraints, imageViewConstraints].flatMap{$0}
        NSLayoutConstraint.activate(constraintsArray)
    }
    
    func addto_centerRecommend() {
        let bigText = DI.shared.getInterfaceExt().frameTextView(text: String(localized: "main_hotel"), font: .boldSystemFont(ofSize: 16), lineHeightMultiple: 0)
        let imageView = UIImageView(image: UIImage(named: "hotelImage"))
        
        bigText.translatesAutoresizingMaskIntoConstraints = false
        let bigTextConstraints = [
            bigText.topAnchor.constraint(equalTo: centerRecommend.topAnchor, constant: 0),
            bigText.leftAnchor.constraint(equalTo: centerRecommend.leftAnchor, constant: 10),
            bigText.widthAnchor.constraint(equalToConstant: 100),
            bigText.heightAnchor.constraint(equalToConstant: 30)
        ]
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let imageViewConstraints = [
            imageView.rightAnchor.constraint(equalTo: centerRecommend.rightAnchor, constant: -10),
            imageView.bottomAnchor.constraint(equalTo: centerRecommend.bottomAnchor, constant: -10),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        centerRecommend.addSubview(bigText)
        centerRecommend.addSubview(imageView)
        
        let constraintsArray = [bigTextConstraints, imageViewConstraints].flatMap{$0}
        NSLayoutConstraint.activate(constraintsArray)
    }
    
    func addto_leftRecommend() {
        let bigText = DI.shared.getInterfaceExt().frameTextView(text: String(localized: "main_restaurant"), font: .boldSystemFont(ofSize: 16), lineHeightMultiple: 0)
        let imageView = UIImageView(image: UIImage(named: "restaurantImage"))
        
        bigText.translatesAutoresizingMaskIntoConstraints = false
        let bigTextConstraints = [
            bigText.topAnchor.constraint(equalTo: leftRecommend.topAnchor, constant: 0),
            bigText.leftAnchor.constraint(equalTo: leftRecommend.leftAnchor, constant: 10),
            bigText.widthAnchor.constraint(equalToConstant: 100),
            bigText.heightAnchor.constraint(equalToConstant: 30)
        ]
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let imageViewConstraints = [
            imageView.rightAnchor.constraint(equalTo: leftRecommend.rightAnchor, constant: -10),
            imageView.bottomAnchor.constraint(equalTo: leftRecommend.bottomAnchor, constant: -10),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        leftRecommend.addSubview(bigText)
        leftRecommend.addSubview(imageView)
        
        let constraintsArray = [bigTextConstraints, imageViewConstraints].flatMap{$0}
        NSLayoutConstraint.activate(constraintsArray)
    }
    
    func addto_rightRecommend() {
        let bigText = DI.shared.getInterfaceExt().frameTextView(text: String(localized: "main_culture"), font: .boldSystemFont(ofSize: 16), lineHeightMultiple: 0)
        let imageView = UIImageView(image: UIImage(named: "cultureImage"))
        
        bigText.translatesAutoresizingMaskIntoConstraints = false
        let bigTextConstraints = [
            bigText.topAnchor.constraint(equalTo: rightRecommend.topAnchor, constant: 0),
            bigText.leftAnchor.constraint(equalTo: rightRecommend.leftAnchor, constant: 10),
            bigText.widthAnchor.constraint(equalToConstant: 100),
            bigText.heightAnchor.constraint(equalToConstant: 30)
        ]
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let imageViewConstraints = [
            imageView.rightAnchor.constraint(equalTo: rightRecommend.rightAnchor, constant: -10),
            imageView.bottomAnchor.constraint(equalTo: rightRecommend.bottomAnchor, constant: -10),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        rightRecommend.addSubview(bigText)
        rightRecommend.addSubview(imageView)
        
        let constraintsArray = [bigTextConstraints, imageViewConstraints].flatMap{$0}
        NSLayoutConstraint.activate(constraintsArray)
    }
    
    func addto_personalRecommend() {
        let bigText = DI.shared.getInterfaceExt().frameTextView(text: String(localized: "main_personal_big"), font: .boldSystemFont(ofSize: 24), lineHeightMultiple: 0.8)
        let smallText = DI.shared.getInterfaceExt().frameTextView(text: String(localized: "main_personal_small"), font: .systemFont(ofSize: 14), lineHeightMultiple: 0.8)
        let imageView = UIImageView(image: UIImage(named: "multiArrowsImage"))
        
        bigText.translatesAutoresizingMaskIntoConstraints = false
        let bigTextConstraints = [
            bigText.topAnchor.constraint(equalTo: personalRecommend.topAnchor, constant: 10),
            bigText.leftAnchor.constraint(equalTo: personalRecommend.leftAnchor, constant: 10),
            bigText.widthAnchor.constraint(equalToConstant: 300),
            bigText.heightAnchor.constraint(equalToConstant: 70)
        ]
        
        smallText.translatesAutoresizingMaskIntoConstraints = false
        let smallTextConstraints = [
            smallText.topAnchor.constraint(equalTo: bigText.bottomAnchor, constant: -15),
            //bigText.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            smallText.leftAnchor.constraint(equalTo: personalRecommend.leftAnchor, constant: 10),
            smallText.widthAnchor.constraint(equalToConstant: 300),
            smallText.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let imageViewConstraints = [
            //imageView.topAnchor.constraint(equalTo: personalRecommend.topAnchor, constant: 15),
            imageView.bottomAnchor.constraint(equalTo: personalRecommend.bottomAnchor, constant: -20),
            imageView.rightAnchor.constraint(equalTo: personalRecommend.rightAnchor, constant: -20),
            //bigText.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 270),
            imageView.heightAnchor.constraint(equalToConstant: 44)
        ]
        
        personalRecommend.addSubview(bigText)
        personalRecommend.addSubview(smallText)
        personalRecommend.addSubview(imageView)
        
        let constraintsArray = [bigTextConstraints, smallTextConstraints, imageViewConstraints].flatMap{$0}
        NSLayoutConstraint.activate(constraintsArray)
    }
    
}

extension MainViewController: MainViewPresenterDelegate {
    func mainViewPresenter(_ reposViewModel: MainViewPresenter, isLoading: Bool) {
        if isLoading { view.showBlurLoader() }
        else {
            view.removeBluerLoader()
            
            userName.text = (UserDefaults.standard.string(forKey: "firstName") ?? "Хуй") + ",\n" + String(localized: "main_top")
        }
    }
}
