//
//  LoginViewController.swift
//  Tinkoff Travel
//
//  Created by Евгений Парфененков on 02.03.2023.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    //let enterButton = UIImage(type: .system)
    let logos = UIImageView(image: UIImage(named: "TINHSE"))
    let enterButton = UIImageView(image: UIImage(named: "TINIDbutton"))
    let bigText = UITextView(frame: CGRect(x: 20.0, y: 90.0, width: 250.0, height: 100.0))
    let smallText = UITextView(frame: CGRect(x: 20.0, y: 90.0, width: 250.0, height: 100.0))
    
    
    override func viewDidLoad() { super.viewDidLoad() }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = UIColor(named: "GreyColor")
        setup()
    }
    
    
    func setup() {
        
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
        
        logos.translatesAutoresizingMaskIntoConstraints = false
        let logosConstraints = [
            logos.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            logos.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //logos.centerYAnchor.constraint(equalTo: view.centerYAnchor),
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
        NSLayoutConstraint.activate(logosConstraints)
        
        view.addSubview(bigText)
        NSLayoutConstraint.activate(bigTextConstraints)
        
        view.addSubview(smallText)
        NSLayoutConstraint.activate(smallTextConstraints)
        
        view.addSubview(enterButton)
        NSLayoutConstraint.activate(enterButtonConstraints)
    }
}

//class customButton: UIView {
//    let button = UIButton(type: .system)
//    let image = UIImage(named: "TINID")
//
//    init() {
//        super.init(frame: .zero)
//        addSubview(button)
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
