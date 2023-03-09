//
//  MainViewController.swift
//  Tinkoff Travel
//
//  Created by Евгений Парфененков on 02.03.2023.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    
    let userImage = UIImageView(image: UIImage(named: "userImage"))
    let userName = UITextView()
    let searchBar = UISearchBar()
    
    let bigRecommend = UIView()
    let centerRecommend = UIView()
    let leftRecommend = UIView()
    let rightRecommend = UIView()
    let personalRecommend = UIView()
    
    let checkAllButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.text = "Евгений,\nкуда отправимся?"
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
        
        searchBar.placeholder = "Британский паб"
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
        
        checkAllButton.setTitle("Посмотреть все", for: .normal)
        checkAllButton.backgroundColor = UIColor(named: "YellowColor")
        checkAllButton.layer.cornerRadius = 23
        checkAllButton.setTitleColor(.black, for: .normal)
        checkAllButton.titleLabel?.font = UIFont(name: "Helvetica Neue Bold", size: 26)
        
        //mem()
        
        setUpConstraints()
    }
    
    func mem() {
        bigRecommend.backgroundColor = .brown
        bigRecommend.layer.cornerRadius = 0
        centerRecommend.backgroundColor = .red
        centerRecommend.layer.cornerRadius = 0
        leftRecommend.backgroundColor = .yellow
        leftRecommend.layer.cornerRadius = 0
        rightRecommend.backgroundColor = .green
        rightRecommend.layer.cornerRadius = 0
        personalRecommend.backgroundColor = .blue
        personalRecommend.layer.cornerRadius = 0
        checkAllButton.backgroundColor = .white
        checkAllButton.layer.cornerRadius = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = .black
    }
    
    // MARK: - Contraints
    
    func setUpConstraints() {
        
        userImage.translatesAutoresizingMaskIntoConstraints = false
        let userImageConstraints = [
            userImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            //userImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
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
            //bigRecommend.widthAnchor.constraint(equalTo: view.widthAnchor)
        ]
        
        centerRecommend.translatesAutoresizingMaskIntoConstraints = false
        let centerRecommendConstraints = [
            centerRecommend.topAnchor.constraint(equalTo: bigRecommend.bottomAnchor, constant: 20),
            centerRecommend.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //centerRecommend.leftAnchor.constraint(equalTo: leftRecommend.rightAnchor, constant: 10),
            //centerRecommend.rightAnchor.constraint(equalTo: searchBar.rightAnchor, constant: 0),
            centerRecommend.heightAnchor.constraint(equalToConstant: 110),
            centerRecommend.widthAnchor.constraint(equalToConstant: 110)
        ]
        
        leftRecommend.translatesAutoresizingMaskIntoConstraints = false
        let leftRecommendConstraints = [
            leftRecommend.topAnchor.constraint(equalTo: bigRecommend.bottomAnchor, constant: 20),
            //leftRecommend.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            leftRecommend.leftAnchor.constraint(equalTo: searchBar.leftAnchor, constant: 10),
            leftRecommend.rightAnchor.constraint(equalTo: centerRecommend.leftAnchor, constant: -20),
            leftRecommend.heightAnchor.constraint(equalToConstant: 110),
            //bigRecommend.widthAnchor.constraint(equalTo: view.widthAnchor)
        ]
        
        rightRecommend.translatesAutoresizingMaskIntoConstraints = false
        let rightRecommendConstraints = [
            rightRecommend.topAnchor.constraint(equalTo: bigRecommend.bottomAnchor, constant: 20),
            //leftRecommend.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rightRecommend.leftAnchor.constraint(equalTo: centerRecommend.rightAnchor, constant: 20),
            rightRecommend.rightAnchor.constraint(equalTo: searchBar.rightAnchor, constant: -10),
            rightRecommend.heightAnchor.constraint(equalToConstant: 110),
            //bigRecommend.widthAnchor.constraint(equalTo: view.widthAnchor)
        ]
        
        personalRecommend.translatesAutoresizingMaskIntoConstraints = false
        let personalRecommendConstraints = [
            personalRecommend.topAnchor.constraint(equalTo: centerRecommend.bottomAnchor, constant: 20),
            personalRecommend.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            personalRecommend.leftAnchor.constraint(equalTo: searchBar.leftAnchor, constant: 10),
            personalRecommend.rightAnchor.constraint(equalTo: searchBar.rightAnchor, constant: -10),
            personalRecommend.heightAnchor.constraint(equalToConstant: 200),
            //bigRecommend.widthAnchor.constraint(equalTo: view.widthAnchor)
        ]
        
        checkAllButton.translatesAutoresizingMaskIntoConstraints = false
        let checkAllButtonConstraints = [
            checkAllButton.topAnchor.constraint(equalTo: personalRecommend.bottomAnchor, constant: 20),
            checkAllButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkAllButton.leftAnchor.constraint(equalTo: searchBar.leftAnchor, constant: 10),
            checkAllButton.rightAnchor.constraint(equalTo: searchBar.rightAnchor, constant: -10),
            checkAllButton.heightAnchor.constraint(equalToConstant: 70),
            //bigRecommend.widthAnchor.constraint(equalTo: view.widthAnchor)
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
        let bigText = UITextView()
        let smallText = UITextView()
        let imageView = UIImageView(image: UIImage(named: "cupImage"))
        
        bigText.text = "Кафе"
        bigText.contentInsetAdjustmentBehavior = .automatic
        bigText.center = self.view.center
        bigText.textAlignment = NSTextAlignment.justified
        bigText.textColor = .white
        bigText.backgroundColor = .clear
        bigText.font = UIFont(name: "Helvetica Neue Bold", size: 30)
        bigText.adjustsFontForContentSizeCategory = false
        bigText.isEditable = false
        bigText.sizeToFit()
        bigText.isScrollEnabled = false
        bigText.setLineSpacing(lineSpacing: 1, lineHeightMultiple: 0.6)
        
        smallText.text = "Для быстрого перекуса"
        smallText.contentInsetAdjustmentBehavior = .automatic
        smallText.center = self.view.center
        smallText.textAlignment = NSTextAlignment.justified
        smallText.textColor = .white
        smallText.backgroundColor = .clear
        smallText.font = UIFont(name: "Helvetica Neue Medium", size: 14)
        smallText.adjustsFontForContentSizeCategory = false
        smallText.isEditable = false
        smallText.sizeToFit()
        smallText.isScrollEnabled = false
        smallText.setLineSpacing(lineSpacing: 1, lineHeightMultiple: 0.6)
        
        bigText.translatesAutoresizingMaskIntoConstraints = false
        let bigTextConstraints = [
            bigText.topAnchor.constraint(equalTo: bigRecommend.topAnchor, constant: 15),
            //bigText.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            bigText.leftAnchor.constraint(equalTo: bigRecommend.leftAnchor, constant: 10),
            bigText.widthAnchor.constraint(equalToConstant: 100),
            bigText.heightAnchor.constraint(equalToConstant: 30)
        ]
        
        smallText.translatesAutoresizingMaskIntoConstraints = false
        let smallTextConstraints = [
            smallText.topAnchor.constraint(equalTo: bigText.bottomAnchor),
            //bigText.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            smallText.leftAnchor.constraint(equalTo: bigRecommend.leftAnchor, constant: 10),
            smallText.widthAnchor.constraint(equalToConstant: 400),
            smallText.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let imageViewConstraints = [
            imageView.topAnchor.constraint(equalTo: bigRecommend.topAnchor, constant: 15),
            imageView.bottomAnchor.constraint(equalTo: bigRecommend.bottomAnchor, constant: -15),
            imageView.rightAnchor.constraint(equalTo: bigRecommend.rightAnchor, constant: -20),
            //bigText.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            //imageView.heightAnchor.constraint(equalToConstant: 80)
        ]
        
        bigRecommend.addSubview(bigText)
        NSLayoutConstraint.activate(bigTextConstraints)
        
        bigRecommend.addSubview(smallText)
        NSLayoutConstraint.activate(smallTextConstraints)
        
        bigRecommend.addSubview(imageView)
        NSLayoutConstraint.activate(imageViewConstraints)
    }
    
    func addto_centerRecommend() {
        let bigText = UITextView()
        let imageView = UIImageView(image: UIImage(named: "hotelImage"))
        
        bigText.text = "Отель"
        bigText.contentInsetAdjustmentBehavior = .automatic
        bigText.center = self.view.center
        bigText.textAlignment = NSTextAlignment.justified
        bigText.textColor = .white
        bigText.backgroundColor = .clear
        bigText.font = UIFont(name: "Helvetica Neue Bold", size: 17)
        bigText.adjustsFontForContentSizeCategory = false
        bigText.isEditable = false
        bigText.sizeToFit()
        bigText.isScrollEnabled = false
        
        
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
        NSLayoutConstraint.activate(bigTextConstraints)
        
        centerRecommend.addSubview(imageView)
        NSLayoutConstraint.activate(imageViewConstraints)
    }
    
    func addto_leftRecommend() {
        let bigText = UITextView()
        let imageView = UIImageView(image: UIImage(named: "restaurantImage"))
        
        bigText.text = "Ресторан"
        bigText.contentInsetAdjustmentBehavior = .automatic
        bigText.center = self.view.center
        bigText.textAlignment = NSTextAlignment.justified
        bigText.textColor = .white
        bigText.backgroundColor = .clear
        bigText.font = UIFont(name: "Helvetica Neue Bold", size: 17)
        bigText.adjustsFontForContentSizeCategory = false
        bigText.isEditable = false
        bigText.sizeToFit()
        bigText.isScrollEnabled = false
        
        
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
        NSLayoutConstraint.activate(bigTextConstraints)
        
        leftRecommend.addSubview(imageView)
        NSLayoutConstraint.activate(imageViewConstraints)
    }
    
    func addto_rightRecommend() {
        let bigText = UITextView()
        let imageView = UIImageView(image: UIImage(named: "cultureImage"))
        
        bigText.text = "Культура"
        bigText.contentInsetAdjustmentBehavior = .automatic
        bigText.center = self.view.center
        bigText.textAlignment = NSTextAlignment.justified
        bigText.textColor = .white
        bigText.backgroundColor = .clear
        bigText.font = UIFont(name: "Helvetica Neue Bold", size: 17)
        bigText.adjustsFontForContentSizeCategory = false
        bigText.isEditable = false
        bigText.sizeToFit()
        bigText.isScrollEnabled = false
        
        
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
        NSLayoutConstraint.activate(bigTextConstraints)
        
        rightRecommend.addSubview(imageView)
        NSLayoutConstraint.activate(imageViewConstraints)
    }
    
    func addto_personalRecommend() {
        let bigText = UITextView()
        let smallText = UITextView()
        let imageView = UIImageView(image: UIImage(named: "multiArrowsImage"))
        
        bigText.text = "Персональные рекомендации"
        bigText.contentInsetAdjustmentBehavior = .automatic
        bigText.center = self.view.center
        bigText.textAlignment = NSTextAlignment.justified
        bigText.textColor = .white
        bigText.backgroundColor = .clear
        bigText.font = UIFont(name: "Helvetica Neue Bold", size: 32)
        bigText.adjustsFontForContentSizeCategory = false
        bigText.isEditable = false
        bigText.sizeToFit()
        bigText.setLineSpacing(lineSpacing: 1, lineHeightMultiple: 0.8)
        bigText.isScrollEnabled = false
        
        smallText.text = "Может, это именно то что нужно"
        smallText.contentInsetAdjustmentBehavior = .automatic
        smallText.center = self.view.center
        smallText.textAlignment = NSTextAlignment.justified
        smallText.textColor = .white
        smallText.backgroundColor = .clear
        smallText.font = UIFont(name: "Helvetica Neue Medium", size: 14)
        smallText.adjustsFontForContentSizeCategory = false
        smallText.isEditable = false
        smallText.sizeToFit()
        smallText.setLineSpacing(lineSpacing: 1, lineHeightMultiple: 0.8)
        smallText.isScrollEnabled = false
        
        bigText.translatesAutoresizingMaskIntoConstraints = false
        let bigTextConstraints = [
            bigText.topAnchor.constraint(equalTo: personalRecommend.topAnchor, constant: 10),
            bigText.leftAnchor.constraint(equalTo: personalRecommend.leftAnchor, constant: 10),
            bigText.widthAnchor.constraint(equalToConstant: 300),
            bigText.heightAnchor.constraint(equalToConstant: 80)
        ]
        
        smallText.translatesAutoresizingMaskIntoConstraints = false
        let smallTextConstraints = [
            smallText.topAnchor.constraint(equalTo: bigText.bottomAnchor),
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
        NSLayoutConstraint.activate(bigTextConstraints)
        
        personalRecommend.addSubview(smallText)
        NSLayoutConstraint.activate(smallTextConstraints)
        
        personalRecommend.addSubview(imageView)
        NSLayoutConstraint.activate(imageViewConstraints)
    }
    
}
