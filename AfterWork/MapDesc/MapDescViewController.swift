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
    let nameText = DI.shared.getInterfaceExt().frameTextView(
        text: "Papa Jhones",
        font: UIFont(name: "Helvetica Neue Condensed Black", size: 36) ?? .boldSystemFont(ofSize: 36),
        lineHeightMultiple: 0.6
    )
    private let lineView = UIView()
    let descriptionText = DI.shared.getInterfaceExt().frameTextView(text: "Ъуй Пхзда Тест", font: UIFont(name: "Helvetica Neue Medium", size: 13) ?? .systemFont(ofSize: 13), lineHeightMultiple: 0.5)

    private let workHoursTitle = DI.shared.getInterfaceExt().frameTextView(text: "Часы работы", font: .boldSystemFont(ofSize: 24), lineHeightMultiple: 0.6)
    let workHoursText = DI.shared.getInterfaceExt().frameTextView(text: "Ежедневно с 12:00 до 23:00", font: .systemFont(ofSize: 16), lineHeightMultiple: 0.6)
    private let lineViewSecond = UIView()

    private let contactsTitle = DI.shared.getInterfaceExt().frameTextView(text: "Контакты", font: .boldSystemFont(ofSize: 24), lineHeightMultiple: 0.6)
    let contactsText = UIButton()
    private let lineViewThird = UIView()

    private let urlTitle = DI.shared.getInterfaceExt().frameTextView(text: "Сайт", font: .boldSystemFont(ofSize: 24), lineHeightMultiple: 0.6)
    var urlText = UIButton()

    private let taxiButton = DI.shared.getInterfaceExt().standardButton(
        title: "Такси", backgroundColor: UIColor(named: "YellowColor") ?? .yellow,
        cornerRadius: 15, titleColor: UIColor(named: "GreyColor") ?? .white,
        font: .systemFont(ofSize: 18)
    )
    private let pathButton = DI.shared.getInterfaceExt().standardButton(
        title: "Маршрут", backgroundColor: UIColor(named: "LightGrayColor") ?? .white,
        cornerRadius: 15, titleColor: .white, font: .systemFont(ofSize: 18)
    )

    var artwork: Artwork?
    var currentCoordinate: CLLocationCoordinate2D?
    var isRecommended: Bool = false

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

        urlText.setTitleColor(.tintColor, for: .normal)
        urlText.backgroundColor = .clear
        urlText.titleLabel?.font = .systemFont(ofSize: 16)

        if isRecommended {
            bigView.layer.shadowColor = UIColor(named: "YellowColor")?.cgColor
            view.layer.shadowOffset = CGSize(width: 0, height: 0)
            bigView.layer.shadowOpacity = 1
            bigView.layer.shadowRadius = 10.0
        }

        taxiButton.addTarget(self, action: #selector(taxiButtonTap), for: .touchUpInside)
        pathButton.addTarget(self, action: #selector(pathButtonTap), for: .touchUpInside)
        contactsText.addTarget(self, action: #selector(contactsTap), for: .touchUpInside)
        urlText.addTarget(self, action: #selector(websiteTap), for: .touchUpInside)

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
            nameText.heightAnchor.constraint(equalToConstant: 30)
        ]

        lineView.translatesAutoresizingMaskIntoConstraints = false
        let lineViewConstraints = [
            lineView.topAnchor.constraint(equalTo: nameText.bottomAnchor, constant: 20),
            lineView.leftAnchor.constraint(equalTo: bigView.leftAnchor, constant: 25),
            lineView.rightAnchor.constraint(equalTo: bigView.rightAnchor, constant: -25),
            lineView.heightAnchor.constraint(equalToConstant: 3)
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
            workHoursTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40)
        ]

        workHoursText.translatesAutoresizingMaskIntoConstraints = false
        let workHoursTextConstraints = [
            workHoursText.topAnchor.constraint(equalTo: workHoursTitle.bottomAnchor, constant: 0),
            workHoursText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
            workHoursText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40)
        ]

        lineViewSecond.translatesAutoresizingMaskIntoConstraints = false
        let lineViewSecondConstraints = [
            lineViewSecond.topAnchor.constraint(equalTo: workHoursText.bottomAnchor, constant: 20),
            lineViewSecond.leftAnchor.constraint(equalTo: bigView.leftAnchor, constant: 5),
            lineViewSecond.rightAnchor.constraint(equalTo: bigView.rightAnchor, constant: -5),
            lineViewSecond.heightAnchor.constraint(equalToConstant: 3)
        ]

        contactsTitle.translatesAutoresizingMaskIntoConstraints = false
        let contactsTitleConstraints = [
            contactsTitle.topAnchor.constraint(equalTo: lineViewSecond.bottomAnchor, constant: 25),
            contactsTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
            contactsTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40)
        ]

        contactsText.translatesAutoresizingMaskIntoConstraints = false
        let contactsTextConstraints = [
            contactsText.topAnchor.constraint(equalTo: contactsTitle.bottomAnchor, constant: 0),
            contactsText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40)
        ]

        lineViewThird.translatesAutoresizingMaskIntoConstraints = false
        let lineViewThirdConstraints = [
            lineViewThird.topAnchor.constraint(equalTo: contactsText.bottomAnchor, constant: 20),
            lineViewThird.leftAnchor.constraint(equalTo: bigView.leftAnchor, constant: 5),
            lineViewThird.rightAnchor.constraint(equalTo: bigView.rightAnchor, constant: -5),
            lineViewThird.heightAnchor.constraint(equalToConstant: 3)
        ]

        urlTitle.translatesAutoresizingMaskIntoConstraints = false
        let urlTitleConstraints = [
            urlTitle.topAnchor.constraint(equalTo: lineViewThird.bottomAnchor, constant: 25),
            urlTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
            urlTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40)
        ]

        urlText.translatesAutoresizingMaskIntoConstraints = false
        let urlTextConstraints = [
            urlText.topAnchor.constraint(equalTo: urlTitle.bottomAnchor, constant: 5),
            urlText.leftAnchor.constraint(equalTo: urlTitle.leftAnchor, constant: 5)

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

        view.addSubview(urlTitle)
        view.addSubview(urlText)

        view.addSubview(taxiButton)
        view.addSubview(pathButton)

        let constraintsArray = [bigViewConstraints, titleTextConstraints, nameTextConstraints, lineViewConstraints, descriptionTextConstraints, workHoursTitleConstraints, workHoursTextConstraints, lineViewSecondConstraints, contactsTitleConstraints, contactsTextConstraints, lineViewThirdConstraints, urlTitleConstraints, urlTextConstraints, taxiButtonConstraints, pathButtonConstraints].flatMap {$0}
        NSLayoutConstraint.activate(constraintsArray)

    }

    @objc private func taxiButtonTap() {
        let start = currentCoordinate
        let end = artwork?.coordinate
        let defaultWebsiteURL = URL(string: "https://3.redirect.appmetrica.yandex.com/route?start-lat=" + String(start?.latitude ?? CLLocationDegrees(0))
                                    + "&start-lon="
                                    + String(start?.longitude ?? CLLocationDegrees(0))
                                    + "&end-lat="
                                    + String(end?.latitude ?? CLLocationDegrees(0))
                                    + "&end-lon="
                                    + String(end?.longitude ?? CLLocationDegrees(0))
                                    + "&level=50&appmetrica_tracking_id=1178268795219780156")!

        UIApplication.shared.open(defaultWebsiteURL)
    }

    @objc private func pathButtonTap() {
        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ]
        artwork?.mapItem?.openInMaps(launchOptions: launchOptions)
    }

    @objc private func contactsTap() {
        presenter.callNumber(phoneNumber: contactsText.title(for: .normal) ?? "https://apple.com")
    }

    @objc private func websiteTap() {
        presenter.openLink(website: urlText.title(for: .normal) ?? "https://apple.com")
    }
}
