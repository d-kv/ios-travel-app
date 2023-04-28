//
//  InterfaceExt.swift
//  AfterWork
//
//  Created by Евгений Парфененков on 15.03.2023.
//

import Foundation
import UIKit
import Shuffle_iOS

protocol InterfaceExtProtocol {
    func lightGreyButton(title: String, color: UIColor) -> UIButton
    func standardButton(title: String, backgroundColor: UIColor, cornerRadius: CGFloat, titleColor: UIColor, font: UIFont) -> UIButton
    func standardTextView(text: String, textColor: UIColor, font: UIFont) -> UITextView
    func frameTextView(text: String, font: UIFont, lineHeightMultiple: CGFloat) -> UITextView
    func card(fromData data: Places) -> SwipeCard
    func basicCard(type: String, title: String, description: String, workHours: String, url: String, isRecommended: Bool) -> UIView
}

class InterfaceExt: InterfaceExtProtocol {

    func lightGreyButton(title: String, color: UIColor) -> UIButton {

        let button = UIButton()

        button.setTitle(title, for: .normal)
        button.backgroundColor = color
        button.layer.cornerRadius = 15
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica Neue Medium", size: 20)

        return button
    }

    func standardButton(title: String, backgroundColor: UIColor, cornerRadius: CGFloat, titleColor: UIColor, font: UIFont) -> UIButton {
        let button = UIButton()

        button.setTitle(title, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = cornerRadius
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = font

        return button
    }

    func standardTextView(text: String, textColor: UIColor, font: UIFont) -> UITextView {
        let textView = UITextView()

        textView.text = text
        textView.contentInsetAdjustmentBehavior = .automatic
        textView.textAlignment = NSTextAlignment.justified
        textView.textColor = textColor
        textView.backgroundColor = .clear
        textView.font = font
        textView.adjustsFontForContentSizeCategory = true
        textView.isEditable = false
        textView.sizeToFit()

        return textView
    }

    func frameTextView(text: String, font: UIFont, lineHeightMultiple: CGFloat) -> UITextView {
        let textView = UITextView()

        textView.text = text
        textView.contentInsetAdjustmentBehavior = .automatic
        textView.textAlignment = NSTextAlignment.justified
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.font = font
        textView.adjustsFontForContentSizeCategory = false
        textView.isEditable = false
        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.isSelectable = false
        if lineHeightMultiple != 0 { textView.setLineSpacing(lineSpacing: 1, lineHeightMultiple: lineHeightMultiple) }

        return textView
    }

    func card(fromData data: Places) -> SwipeCard {
        let card = SwipeCard()

        let content = DI.shared.getInterfaceExt().basicCard(
            type: data.category, title: data.name, description: data.description,
            workHours: data.availability, url: data.url, isRecommended: data.isRecommended
        )

        card.swipeDirections = [.left, .right]
        card.content = content

        let leftOverlay = UIView()
        leftOverlay.layer.cornerRadius = 23
        leftOverlay.backgroundColor = .red

        let rightOverlay = UIView()
        rightOverlay.layer.cornerRadius = 23
        rightOverlay.backgroundColor = UIColor(named: "YellowColor")

        card.setOverlays([.left: leftOverlay, .right: rightOverlay])

        return card
    }

    func basicCard(type: String, title: String, description: String, workHours: String, url: String, isRecommended: Bool) -> UIView {

        let view = UIView()

        let typeText = self.frameTextView(text: type, font: .boldSystemFont(ofSize: 16), lineHeightMultiple: 0.5)
        let nameText = self.frameTextView(text: title, font: UIFont(name: "Helvetica Neue Condensed Black", size: 36) ?? .boldSystemFont(ofSize: 36), lineHeightMultiple: 0.7)
        let descriptionText = self.frameTextView(text: description, font: UIFont(name: "Helvetica Neue Medium", size: 14) ?? .systemFont(ofSize: 14), lineHeightMultiple: 0)

        let viewRectangle = UIView()
        let hideRectangle = UIView()

        let workHouseTitle = self.frameTextView(text: String(localized: "cards_workhours"), font: .boldSystemFont(ofSize: 28), lineHeightMultiple: 0.6)
        let workHouseText = self.frameTextView(text: workHours, font: UIFont(name: "Helvetica Neue Medium", size: 14) ?? .systemFont(ofSize: 14), lineHeightMultiple: 0.5)

        let urlTitle = self.frameTextView(text: String(localized: "cards_bill"), font: .boldSystemFont(ofSize: 28), lineHeightMultiple: 0.6)
        let urlText = UIButton()

        if isRecommended {

            view.layer.shadowColor = UIColor(named: "YellowColor")?.cgColor
            view.layer.shadowOpacity = 1
            view.layer.shadowRadius = 10.0
        }

        descriptionText.textAlignment = NSTextAlignment.right

        viewRectangle.layer.borderWidth = 2
        viewRectangle.layer.borderColor = UIColor.white.cgColor

        hideRectangle.layer.borderWidth = 2
        hideRectangle.layer.borderColor = UIColor(named: "GreyColor")?.cgColor

        urlText.setTitle(url, for: .normal)
        urlText.setTitleColor(.tintColor, for: .normal)


        return preCreatinonBasicCard(view: view, typeText: typeText, nameText: nameText, descriptionText: descriptionText, viewRectangle: viewRectangle, hideRectangle: hideRectangle, workHouseTitle: workHouseTitle, workHouseText: workHouseText, urlTitle: urlTitle, urlText: urlText)
    }
    
    private func prepareConstraints(view: UIView, typeText: UITextView, nameText: UITextView, descriptionText: UITextView, viewRectangle: UIView, hideRectangle: UIView, workHouseTitle: UITextView, workHouseText: UITextView, urlTitle: UITextView, urlText: UIButton) -> [[NSLayoutConstraint]] {
        typeText.translatesAutoresizingMaskIntoConstraints = false
        let typeTextConstraints = [
            typeText.topAnchor.constraint(equalTo: view.topAnchor, constant: 25),
            typeText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            typeText.widthAnchor.constraint(equalToConstant: 130),
            typeText.heightAnchor.constraint(equalToConstant: 20)
        ]

        nameText.translatesAutoresizingMaskIntoConstraints = false
        let nameTextConstraints = [
            nameText.topAnchor.constraint(equalTo: typeText.bottomAnchor, constant: 0),
            nameText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            nameText.widthAnchor.constraint(equalTo: view.widthAnchor),
            nameText.heightAnchor.constraint(equalToConstant: 40)
        ]

        viewRectangle.translatesAutoresizingMaskIntoConstraints = false
        let viewRectangleConstraints = [
            viewRectangle.topAnchor.constraint(equalTo: nameText.bottomAnchor, constant: 20),
            viewRectangle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewRectangle.widthAnchor.constraint(equalToConstant: 270),
            viewRectangle.heightAnchor.constraint(equalToConstant: 140)
        ]

        hideRectangle.translatesAutoresizingMaskIntoConstraints = false
        let hideRectangleConstraints = [
            hideRectangle.topAnchor.constraint(equalTo: nameText.bottomAnchor, constant: 22),
            hideRectangle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hideRectangle.widthAnchor.constraint(equalToConstant: 270),
            hideRectangle.heightAnchor.constraint(equalToConstant: 140)
        ]

        descriptionText.translatesAutoresizingMaskIntoConstraints = false
        let descriptionTextConstraints = [
            descriptionText.topAnchor.constraint(equalTo: viewRectangle.topAnchor, constant: 10),
            descriptionText.leftAnchor.constraint(equalTo: viewRectangle.leftAnchor, constant: -15),
            descriptionText.rightAnchor.constraint(equalTo: viewRectangle.rightAnchor),
            descriptionText.bottomAnchor.constraint(equalTo: viewRectangle.bottomAnchor, constant: -10)
        ]

        workHouseTitle.translatesAutoresizingMaskIntoConstraints = false
        let workHouseTitleConstraints = [
            workHouseTitle.topAnchor.constraint(equalTo: hideRectangle.bottomAnchor, constant: 25),
            workHouseTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            workHouseTitle.widthAnchor.constraint(equalToConstant: 200),
            workHouseTitle.heightAnchor.constraint(equalToConstant: 30)
        ]
        return [typeTextConstraints, nameTextConstraints, viewRectangleConstraints, hideRectangleConstraints, descriptionTextConstraints, workHouseTitleConstraints]
    }
    
    private func preCreatinonBasicCard(view: UIView, typeText: UITextView, nameText: UITextView, descriptionText: UITextView, viewRectangle: UIView, hideRectangle: UIView, workHouseTitle: UITextView, workHouseText: UITextView, urlTitle: UITextView, urlText: UIButton) -> UIView {
        
        workHouseText.translatesAutoresizingMaskIntoConstraints = false
        let workHouseTextConstraints = [
            workHouseText.topAnchor.constraint(equalTo: workHouseTitle.bottomAnchor, constant: 5),
            workHouseText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            workHouseText.widthAnchor.constraint(equalToConstant: 200),
            workHouseText.heightAnchor.constraint(equalToConstant: 20)
        ]

        urlTitle.translatesAutoresizingMaskIntoConstraints = false
        let urlTitleConstraints = [
            urlTitle.topAnchor.constraint(equalTo: workHouseText.bottomAnchor, constant: 25),
            urlTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            urlTitle.widthAnchor.constraint(equalToConstant: 200),
            urlTitle.heightAnchor.constraint(equalToConstant: 30)
        ]

        urlText.translatesAutoresizingMaskIntoConstraints = false
        let urlTextConstraints = [
            urlText.topAnchor.constraint(equalTo: urlTitle.bottomAnchor, constant: 10),
            urlText.leftAnchor.constraint(equalTo: urlTitle.leftAnchor, constant: 6),
            urlText.heightAnchor.constraint(equalToConstant: 20)
        ]

        view.addSubview(typeText)
        view.addSubview(nameText)
        view.addSubview(viewRectangle)
        view.addSubview(hideRectangle)
        view.addSubview(descriptionText)
        view.addSubview(workHouseTitle)
        view.addSubview(workHouseText)
        view.addSubview(urlTitle)
        view.addSubview(urlText)
        let constraintsArray = [workHouseTextConstraints, urlTitleConstraints, urlTextConstraints].flatMap {$0}
        NSLayoutConstraint.activate(constraintsArray)
        NSLayoutConstraint.activate(prepareConstraints(view: view, typeText: typeText, nameText: nameText, descriptionText: descriptionText, viewRectangle: viewRectangle, hideRectangle: hideRectangle, workHouseTitle: workHouseTitle, workHouseText: workHouseText, urlTitle: urlTitle, urlText: urlText).flatMap {$0})

        if typeText.text == "Инструкция" {
            workHouseTitle.isHidden = true
            workHouseText.isHidden = true
            urlTitle.isHidden = true
            urlText.isHidden = true
        }
        view.backgroundColor = UIColor(named: "GreyColor")
        view.layer.cornerRadius = 23
        
        return view
    }
}
