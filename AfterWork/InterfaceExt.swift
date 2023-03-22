//
//  InterfaceExt.swift
//  AfterWork
//
//  Created by Евгений Парфененков on 15.03.2023.
//

import Foundation
import UIKit

class InterfaceExt {
  func lightGreyButton(title: String, color: UIColor) -> UIButton {
    let button = UIButton()

    button.setTitle(title, for: .normal)
    button.backgroundColor = color
    button.layer.cornerRadius = 15
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = UIFont(name: "Helvetica Neue Medium", size: 20)

    return button
  }

  func basicCard(
    type: String,
    title: String,
    description: String,
    workHours: String,
    bill: Int,
    isRecommended: Bool
  )
    -> UIView {
    let view = UIView()

    let typeText = UITextView()
    let nameText = UITextView()
    let descriptionText = UITextView()

    let viewRectangle = UIView()
    let hideRectangle = UIView()

    let workHouseTitle = UITextView()
    let workHouseText = UITextView()

    let billTitle = UITextView()
    let billPrice = worstPrice(price: bill)

    if isRecommended {
      // view.layer.borderWidth = 1
      // view.layer.borderColor = UIColor(named: "YellowColor")?.cgColor

      view.layer.shadowColor = UIColor(named: "YellowColor")?.cgColor
      // view.layer.shadowOffset = CGSize(width: 0, height: 0)
      view.layer.shadowOpacity = 1
      view.layer.shadowRadius = 10.0
    }

    typeText.text = type
    typeText.contentInsetAdjustmentBehavior = .automatic
    typeText.center = view.center
    typeText.textAlignment = NSTextAlignment.justified
    typeText.textColor = .white
    typeText.backgroundColor = .clear
    typeText.font = UIFont(name: "Helvetica Neue Bold", size: 16)
    typeText.adjustsFontForContentSizeCategory = false
    typeText.isEditable = false
    typeText.sizeToFit()
    typeText.isScrollEnabled = false
    typeText.isSelectable = false
    typeText.setLineSpacing(lineSpacing: 0, lineHeightMultiple: 0.5)

    nameText.text = title
    nameText.contentInsetAdjustmentBehavior = .automatic
    nameText.center = view.center
    nameText.textAlignment = NSTextAlignment.justified
    nameText.textColor = .white
    nameText.backgroundColor = .clear
    nameText.font = UIFont(name: "Helvetica Neue Condensed Black", size: 36)
    nameText.adjustsFontForContentSizeCategory = false
    nameText.isEditable = false
    nameText.sizeToFit()
    nameText.isScrollEnabled = false
    nameText.isSelectable = false
    nameText.setLineSpacing(lineSpacing: 0, lineHeightMultiple: 0.7)

    descriptionText.text = description
    descriptionText.contentInsetAdjustmentBehavior = .automatic
    descriptionText.center = view.center
    descriptionText.textAlignment = NSTextAlignment.right
    descriptionText.textColor = .white
    descriptionText.backgroundColor = .clear
    descriptionText.font = UIFont(name: "Helvetica Neue Medium", size: 14)
    descriptionText.isEditable = false
    descriptionText.sizeToFit()
    descriptionText.isScrollEnabled = false
    descriptionText.isSelectable = false
    descriptionText.adjustsFontForContentSizeCategory = true

    viewRectangle.layer.borderWidth = 2
    viewRectangle.layer.borderColor = UIColor.white.cgColor

    hideRectangle.layer.borderWidth = 2
    hideRectangle.layer.borderColor = UIColor(named: "GreyColor")!.cgColor

    workHouseTitle.text = "Часы работы"
    workHouseTitle.contentInsetAdjustmentBehavior = .automatic
    workHouseTitle.center = view.center
    workHouseTitle.textAlignment = NSTextAlignment.justified
    workHouseTitle.textColor = .white
    workHouseTitle.backgroundColor = .clear
    workHouseTitle.font = UIFont(name: "Helvetica Neue Bold", size: 28)
    workHouseTitle.adjustsFontForContentSizeCategory = false
    workHouseTitle.isEditable = false
    workHouseTitle.sizeToFit()
    workHouseTitle.isScrollEnabled = false
    workHouseTitle.isSelectable = false
    workHouseTitle.setLineSpacing(lineSpacing: 1, lineHeightMultiple: 0.6)

    workHouseText.text = workHours
    workHouseText.contentInsetAdjustmentBehavior = .automatic
    workHouseText.center = view.center
    workHouseText.textAlignment = NSTextAlignment.justified
    workHouseText.textColor = .white
    workHouseText.backgroundColor = .clear
    workHouseText.font = UIFont(name: "Helvetica Neue Medium", size: 14)
    workHouseText.adjustsFontForContentSizeCategory = false
    workHouseText.isEditable = false
    workHouseText.sizeToFit()
    workHouseText.isScrollEnabled = false
    workHouseText.isSelectable = false
    workHouseText.setLineSpacing(lineSpacing: 0, lineHeightMultiple: 0.5)

    billTitle.text = "Средний чек"
    billTitle.contentInsetAdjustmentBehavior = .automatic
    billTitle.center = view.center
    billTitle.textAlignment = NSTextAlignment.justified
    billTitle.textColor = .white
    billTitle.backgroundColor = .clear
    billTitle.font = UIFont(name: "Helvetica Neue Bold", size: 28)
    billTitle.adjustsFontForContentSizeCategory = false
    billTitle.isEditable = false
    billTitle.sizeToFit()
    billTitle.isScrollEnabled = false
    billTitle.isSelectable = false
    billTitle.setLineSpacing(lineSpacing: 1, lineHeightMultiple: 0.6)

//        billPrice.layer.backgroundColor = UIColor.white.cgColor
//        billPrice.backgroundColor = .white

    typeText.translatesAutoresizingMaskIntoConstraints = false
    let typeTextConstraints = [
      typeText.topAnchor.constraint(equalTo: view.topAnchor, constant: 25),
      typeText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
      typeText.widthAnchor.constraint(equalToConstant: 130),
      typeText.heightAnchor.constraint(equalToConstant: 20),
    ]

    nameText.translatesAutoresizingMaskIntoConstraints = false
    let nameTextConstraints = [
      nameText.topAnchor.constraint(equalTo: typeText.bottomAnchor, constant: 0),
      nameText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
      nameText.widthAnchor.constraint(equalTo: view.widthAnchor),
      nameText.heightAnchor.constraint(equalToConstant: 40),
    ]

    viewRectangle.translatesAutoresizingMaskIntoConstraints = false
    let viewRectangleConstraints = [
      viewRectangle.topAnchor.constraint(equalTo: nameText.bottomAnchor, constant: 20),
      viewRectangle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      viewRectangle.widthAnchor.constraint(equalToConstant: 270),
      viewRectangle.heightAnchor.constraint(equalToConstant: 140),
    ]

    hideRectangle.translatesAutoresizingMaskIntoConstraints = false
    let hideRectangleConstraints = [
      hideRectangle.topAnchor.constraint(equalTo: nameText.bottomAnchor, constant: 22),
      hideRectangle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      hideRectangle.widthAnchor.constraint(equalToConstant: 270),
      hideRectangle.heightAnchor.constraint(equalToConstant: 140),
    ]

    descriptionText.translatesAutoresizingMaskIntoConstraints = false
    let descriptionTextConstraints = [
      descriptionText.topAnchor.constraint(equalTo: viewRectangle.topAnchor, constant: 10),
      descriptionText.leftAnchor.constraint(equalTo: viewRectangle.leftAnchor, constant: -15),
      descriptionText.rightAnchor.constraint(equalTo: viewRectangle.rightAnchor),
      descriptionText.bottomAnchor.constraint(
        equalTo: viewRectangle.bottomAnchor,
        constant: -10
      ),
      // descriptionText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      // descriptionText.widthAnchor.constraint(equalToConstant: 300),
      // descriptionText.heightAnchor.constraint(equalToConstant: 100)
    ]

    workHouseTitle.translatesAutoresizingMaskIntoConstraints = false
    let workHouseTitleConstraints = [
      workHouseTitle.topAnchor.constraint(equalTo: hideRectangle.bottomAnchor, constant: 25),
      workHouseTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
      workHouseTitle.widthAnchor.constraint(equalToConstant: 200),
      workHouseTitle.heightAnchor.constraint(equalToConstant: 30),
    ]

    workHouseText.translatesAutoresizingMaskIntoConstraints = false
    let workHouseTextConstraints = [
      workHouseText.topAnchor.constraint(equalTo: workHouseTitle.bottomAnchor, constant: 5),
      workHouseText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
      workHouseText.widthAnchor.constraint(equalToConstant: 200),
      workHouseText.heightAnchor.constraint(equalToConstant: 20),
    ]

    billTitle.translatesAutoresizingMaskIntoConstraints = false
    let billTitleConstraints = [
      billTitle.topAnchor.constraint(equalTo: workHouseText.bottomAnchor, constant: 25),
      billTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
      billTitle.widthAnchor.constraint(equalToConstant: 200),
      billTitle.heightAnchor.constraint(equalToConstant: 30),
    ]

    billPrice.translatesAutoresizingMaskIntoConstraints = false
    let billPriceConstraints = [
      billPrice.topAnchor.constraint(equalTo: billTitle.bottomAnchor, constant: 10),
      billPrice.leftAnchor.constraint(equalTo: billTitle.leftAnchor, constant: 6),
      billPrice.widthAnchor.constraint(equalToConstant: 200),
      billPrice.heightAnchor.constraint(equalToConstant: 20),
    ]

    view.addSubview(typeText)
    NSLayoutConstraint.activate(typeTextConstraints)

    view.addSubview(nameText)
    NSLayoutConstraint.activate(nameTextConstraints)

    view.addSubview(viewRectangle)
    NSLayoutConstraint.activate(viewRectangleConstraints)

    view.addSubview(hideRectangle)
    NSLayoutConstraint.activate(hideRectangleConstraints)

    view.addSubview(descriptionText)
    NSLayoutConstraint.activate(descriptionTextConstraints)

    view.addSubview(workHouseTitle)
    NSLayoutConstraint.activate(workHouseTitleConstraints)

    view.addSubview(workHouseText)
    NSLayoutConstraint.activate(workHouseTextConstraints)

    view.addSubview(billTitle)
    NSLayoutConstraint.activate(billTitleConstraints)

    view.addSubview(billPrice)
    NSLayoutConstraint.activate(billPriceConstraints)

    if typeText.text == "Инструкция" {
      workHouseTitle.isHidden = true
      workHouseText.isHidden = true
      billTitle.isHidden = true
      billPrice.isHidden = true
    }

    view.backgroundColor = UIColor(named: "GreyColor")
    view.layer.cornerRadius = 23

    return view
  }

  func worstPrice(price: Int) -> UIView {
    let view = UIView()

    var counter = 0

    for _ in stride(from: 0, to: price, by: 1) {
      let image = UIImageView(image: UIImage(named: "rubleImage"))
      image.tintColor = UIColor(named: "YellowColor")

      image.translatesAutoresizingMaskIntoConstraints = false
      let imageConstraints = [
        image.topAnchor.constraint(equalTo: view.topAnchor),
        image.leftAnchor.constraint(
          equalTo: view.leftAnchor,
          constant: CGFloat(25 * counter)
        ),
        image.widthAnchor.constraint(equalToConstant: 20),
        image.heightAnchor.constraint(equalToConstant: 20),
      ]

      view.addSubview(image)
      NSLayoutConstraint.activate(imageConstraints)
      counter += 1
    }

    for _ in stride(from: 0, to: 5 - price, by: 1) {
      let image = UIImageView(image: UIImage(named: "rubleImage"))
      image.tintColor = .white

      image.translatesAutoresizingMaskIntoConstraints = false
      let imageConstraints = [
        image.topAnchor.constraint(equalTo: view.topAnchor),
        image.leftAnchor.constraint(
          equalTo: view.leftAnchor,
          constant: CGFloat(25 * counter)
        ),
        image.widthAnchor.constraint(equalToConstant: 20),
        image.heightAnchor.constraint(equalToConstant: 20),
      ]

      view.addSubview(image)
      NSLayoutConstraint.activate(imageConstraints)
      counter += 1
    }
    return view
  }
}
