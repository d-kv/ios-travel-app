//
//  MapDescViewController.swift
//  AfterWork
//
//  Created by Евгений Парфененков on 23.03.2023.
//

import Foundation
import UIKit
import MapKit

class MapDescViewController: UIViewController {
    
    private let presenter = DI.shared.getMapDescViewPresenter()
    
    private let bigView = UIView()
    
    let titleText = DI.shared.getInterfaceExt().frameTextView(text: "Пиццерия", font: .boldSystemFont(ofSize: 16), lineHeightMultiple: 0.6)
    let nameText = DI.shared.getInterfaceExt().frameTextView(text: "Papa Jhones", font: UIFont(name: "Helvetica Neue Condensed Black", size: 36)!, lineHeightMultiple: 0.6)
    private let lineView = UIView()
    let descriptionText = DI.shared.getInterfaceExt().frameTextView(text: "Ъуй Пхзда Тест", font: UIFont(name: "Helvetica Neue Medium", size: 13)!, lineHeightMultiple: 0.5)
    
    private let workHoursTitle = DI.shared.getInterfaceExt().frameTextView(text: "Часы работы", font: .boldSystemFont(ofSize: 24), lineHeightMultiple: 0.6)
    let workHoursText = DI.shared.getInterfaceExt().frameTextView(text: "Ежедневно с 12:00 до 23:00", font: .systemFont(ofSize: 16), lineHeightMultiple: 0.6)
    private let lineViewSecond = UIView()
    
    private let contactsTitle = DI.shared.getInterfaceExt().frameTextView(text: "Контакты", font: .boldSystemFont(ofSize: 24), lineHeightMultiple: 0.6)
    let contactsText = UIButton()
//    let contactsText = DI.shared.getInterfaceExt().frameTextView(text: "+7 (999) 999 99-99", font: .systemFont(ofSize: 14), lineHeightMultiple: 0.6)
    private let lineViewThird = UIView()
    
    private let billTitle = DI.shared.getInterfaceExt().frameTextView(text: "Cредний чек", font: .boldSystemFont(ofSize: 24), lineHeightMultiple: 0.6)
    var billText = DI.shared.getInterfaceExt().worstPrice(price: 4)
    
    private let taxiButton = DI.shared.getInterfaceExt().standardButton(title: "Такси", backgroundColor: UIColor(named: "YellowColor")!, cornerRadius: 15, titleColor: UIColor(named: "GreyColor")!, font: .systemFont(ofSize: 18))
    private let pathButton = DI.shared.getInterfaceExt().standardButton(title: "Маршрут", backgroundColor: UIColor(named: "LightGrayColor")!, cornerRadius: 15, titleColor: .white, font: .systemFont(ofSize: 18))
    
    var artwork: Artwork? = nil
    var currentCoordinate: CLLocationCoordinate2D? = nil
    var isRecomended: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        create()
        setUpConstraints()
    }
    
    private func create() {
        view.backgroundColor = UIColor(named: "GreyColor")
        
        bigView.backgroundColor = UIColor(named: "LightGrayColor")
        bigView.layer.cornerRadius = 20
        
        lineView.backgroundColor = .white
        lineViewSecond.backgroundColor = .white
        lineViewThird.backgroundColor = .white
        
        descriptionText.textAlignment = .right
        
        contactsText.setTitleColor(.tintColor, for: .normal)
        contactsText.backgroundColor = .clear
        contactsText.titleLabel?.font = .systemFont(ofSize: 16)
        
        if isRecomended {
            bigView.layer.shadowColor = UIColor(named: "YellowColor")?.cgColor
            view.layer.shadowOffset = CGSize(width: 0, height: 0)
            bigView.layer.shadowOpacity = 1
            bigView.layer.shadowRadius = 10.0
        }

        taxiButton.addTarget(self, action: #selector(taxiButtonTap), for: .touchUpInside)
        pathButton.addTarget(self, action: #selector(pathButtonTap), for: .touchUpInside)
        contactsText.addTarget(self, action: #selector(contactsTap), for: .touchUpInside)
        
    }
    
    private func setUpConstraints() {
        
        bigView.translatesAutoresizingMaskIntoConstraints = false
        let bigViewConstraints = [
            bigView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            bigView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25),
            bigView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25),
            bigView.heightAnchor.constraint(equalToConstant: 240)
        ]
        
        titleText.translatesAutoresizingMaskIntoConstraints = false
        let titleTextConstraints = [
            titleText.topAnchor.constraint(equalTo: bigView.topAnchor, constant: 15),
            titleText.leftAnchor.constraint(equalTo: bigView.leftAnchor, constant: 15),
            titleText.rightAnchor.constraint(equalTo: bigView.rightAnchor, constant: -15),
            titleText.heightAnchor.constraint(equalToConstant: 25)
        ]
        
        nameText.translatesAutoresizingMaskIntoConstraints = false
        let nameTextConstraints = [
            nameText.topAnchor.constraint(equalTo: titleText.bottomAnchor),
            nameText.leftAnchor.constraint(equalTo: bigView.leftAnchor, constant: 15),
            nameText.rightAnchor.constraint(equalTo: bigView.rightAnchor, constant: -15),
            nameText.heightAnchor.constraint(equalToConstant: 30),
        ]
        
        lineView.translatesAutoresizingMaskIntoConstraints = false
        let lineViewConstraints = [
            lineView.topAnchor.constraint(equalTo: nameText.bottomAnchor, constant: 20),
            lineView.leftAnchor.constraint(equalTo: bigView.leftAnchor, constant: 25),
            lineView.rightAnchor.constraint(equalTo: bigView.rightAnchor, constant: -25),
            lineView.heightAnchor.constraint(equalToConstant: 3),
        ]
        
        descriptionText.translatesAutoresizingMaskIntoConstraints = false
        let descriptionTextConstraints = [
            descriptionText.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 15),
            descriptionText.leftAnchor.constraint(equalTo: bigView.leftAnchor, constant: 15),
            descriptionText.rightAnchor.constraint(equalTo: bigView.rightAnchor, constant: -15),
            descriptionText.bottomAnchor.constraint(equalTo: bigView.bottomAnchor, constant: -15)
        ]
        
        workHoursTitle.translatesAutoresizingMaskIntoConstraints = false
        let workHoursTitleConstraints = [
            workHoursTitle.topAnchor.constraint(equalTo: bigView.bottomAnchor, constant: 25),
            workHoursTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
            workHoursTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
            //nameText.heightAnchor.constraint(equalToConstant: 30),
        ]
        
        workHoursText.translatesAutoresizingMaskIntoConstraints = false
        let workHoursTextConstraints = [
            workHoursText.topAnchor.constraint(equalTo: workHoursTitle.bottomAnchor, constant: 0),
            workHoursText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
            workHoursText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
            //workHoursText.heightAnchor.constraint(equalToConstant: 30),
        ]
        
        lineViewSecond.translatesAutoresizingMaskIntoConstraints = false
        let lineViewSecondConstraints = [
            lineViewSecond.topAnchor.constraint(equalTo: workHoursText.bottomAnchor, constant: 20),
            lineViewSecond.leftAnchor.constraint(equalTo: bigView.leftAnchor, constant: 5),
            lineViewSecond.rightAnchor.constraint(equalTo: bigView.rightAnchor, constant: -5),
            lineViewSecond.heightAnchor.constraint(equalToConstant: 3),
        ]
        
        contactsTitle.translatesAutoresizingMaskIntoConstraints = false
        let contactsTitleConstraints = [
            contactsTitle.topAnchor.constraint(equalTo: lineViewSecond.bottomAnchor, constant: 25),
            contactsTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
            contactsTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
            //nameText.heightAnchor.constraint(equalToConstant: 30),
        ]
        
        contactsText.translatesAutoresizingMaskIntoConstraints = false
        let contactsTextConstraints = [
            contactsText.topAnchor.constraint(equalTo: contactsTitle.bottomAnchor, constant: 0),
            contactsText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
            //contactsText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
            //workHoursText.heightAnchor.constraint(equalToConstant: 30),
        ]
        
        lineViewThird.translatesAutoresizingMaskIntoConstraints = false
        let lineViewThirdConstraints = [
            lineViewThird.topAnchor.constraint(equalTo: contactsText.bottomAnchor, constant: 20),
            lineViewThird.leftAnchor.constraint(equalTo: bigView.leftAnchor, constant: 5),
            lineViewThird.rightAnchor.constraint(equalTo: bigView.rightAnchor, constant: -5),
            lineViewThird.heightAnchor.constraint(equalToConstant: 3),
        ]
        
        billTitle.translatesAutoresizingMaskIntoConstraints = false
        let billTitleConstraints = [
            billTitle.topAnchor.constraint(equalTo: lineViewThird.bottomAnchor, constant: 25),
            billTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
            billTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
            //workHoursText.heightAnchor.constraint(equalToConstant: 30),
        ]
        
        billText.translatesAutoresizingMaskIntoConstraints = false
        let billTextConstraints = [
            billText.topAnchor.constraint(equalTo: billTitle.bottomAnchor, constant: 5),
            billText.leftAnchor.constraint(equalTo: bigView.leftAnchor, constant: 20)
        ]
        
        taxiButton.translatesAutoresizingMaskIntoConstraints = false
        let taxiButtonConstraints = [
            taxiButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            taxiButton.leftAnchor.constraint(equalTo: bigView.leftAnchor, constant: 15),
            taxiButton.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            taxiButton.heightAnchor.constraint(equalToConstant: 45)
        ]
        
        pathButton.translatesAutoresizingMaskIntoConstraints = false
        let pathButtonConstraints = [
            pathButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            pathButton.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            pathButton.rightAnchor.constraint(equalTo: bigView.rightAnchor, constant: -15),
            pathButton.heightAnchor.constraint(equalToConstant: 45)
        ]
        
        view.addSubview(bigView)
                
        view.addSubview(titleText)
        view.addSubview(nameText)
        view.addSubview(lineView)
        view.addSubview(descriptionText)
        
        view.addSubview(workHoursTitle)
        view.addSubview(workHoursText)
        view.addSubview(lineViewSecond)
        
        view.addSubview(contactsTitle)
        view.addSubview(contactsText)
        view.addSubview(lineViewThird)
        
        view.addSubview(billTitle)
        view.addSubview(billText)
        
        view.addSubview(taxiButton)
        view.addSubview(pathButton)
        
        let constraintsArray = [bigViewConstraints, titleTextConstraints, nameTextConstraints, lineViewConstraints, descriptionTextConstraints, workHoursTitleConstraints, workHoursTextConstraints, lineViewSecondConstraints, contactsTitleConstraints, contactsTextConstraints, lineViewThirdConstraints, billTitleConstraints, billTextConstraints, taxiButtonConstraints, pathButtonConstraints].flatMap{$0}
        NSLayoutConstraint.activate(constraintsArray)
        
    }
    
    @objc private func taxiButtonTap() {
        let start = currentCoordinate
        let end = artwork?.coordinate
        let defaultWebsiteURL = URL(string: "https://3.redirect.appmetrica.yandex.com/route?start-lat=" + String(start!.latitude) + "&start-lon=" + String(start!.longitude) + "&end-lat=" + String(end!.latitude) + "&end-lon=" + String(end!.longitude) + "&level=50&appmetrica_tracking_id=1178268795219780156")!

        UIApplication.shared.open(defaultWebsiteURL)
    }
    
    @objc private func pathButtonTap() {
        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
        ]
        artwork?.mapItem?.openInMaps(launchOptions: launchOptions)
    }
    
    @objc private func contactsTap() {
        DI.shared.getMapDescViewPresenter().callNumber(phoneNumber: contactsText.title(for: .normal)!)
    }
}
