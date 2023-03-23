//
//  InterfaceExt.swift
//  AfterWork
//
//  Created by Евгений Парфененков on 15.03.2023.
//

import Foundation
import UIKit
import Shuffle_iOS

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
    
    func standardButton(title: String, backgroundColor: UIColor, cornerRadius: CGFloat, titleColor: UIColor, font: UIFont) -> UIButton {
        let button = UIButton()
        
        button.setTitle(title, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = cornerRadius
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel!.font = font
        
        return button
    }
    
    func standardTextView(text: String, textColor: UIColor, font: UIFont) -> UITextView {
        let textView = UITextView()
        
        textView.text = text
        textView.contentInsetAdjustmentBehavior = .automatic
        //textView.center = view.center
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
    
    func card(fromData data: [Any]) -> SwipeCard {
        let card = SwipeCard()
    
        let content = DI.shared.getInterfaceExt().basicCard(type: data[1] as! String, title: data[2] as! String, description: data[6] as! String, workHours: data[10] as! String, bill: data[8] as! Int, isRecommended: data[7] as! Bool)
        
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
    
    func basicCard(type: String, title: String, description: String, workHours: String, bill: Int, isRecommended: Bool) -> UIView {
        
        let view = UIView()
        
        let typeText = self.frameTextView(text: type, font: .boldSystemFont(ofSize: 16), lineHeightMultiple: 0.5)
        let nameText = self.frameTextView(text: title, font: UIFont(name: "Helvetica Neue Condensed Black", size: 36)!, lineHeightMultiple: 0.7)
        let descriptionText = self.frameTextView(text: description, font: UIFont(name: "Helvetica Neue Medium", size: 14)!, lineHeightMultiple: 0)
        
        let viewRectangle = UIView()
        let hideRectangle = UIView()
        
        let workHouseTitle = self.frameTextView(text: String(localized: "cards_workhours"), font: .boldSystemFont(ofSize: 28), lineHeightMultiple: 0.6)
        let workHouseText = self.frameTextView(text: workHours, font: UIFont(name: "Helvetica Neue Medium", size: 14)!, lineHeightMultiple: 0.5)
        
        let billTitle = self.frameTextView(text: String(localized: "cards_bill"), font: .boldSystemFont(ofSize: 28), lineHeightMultiple: 0.6)
        let billPrice = worstPrice(price: bill)
        
        if isRecommended {
            
            view.layer.shadowColor = UIColor(named: "YellowColor")?.cgColor
            //view.layer.shadowOffset = CGSize(width: 0, height: 0)
            view.layer.shadowOpacity = 1
            view.layer.shadowRadius = 10.0
        }
        
        descriptionText.textAlignment = NSTextAlignment.right
        
        viewRectangle.layer.borderWidth = 2
        viewRectangle.layer.borderColor = UIColor.white.cgColor
        
        hideRectangle.layer.borderWidth = 2
        hideRectangle.layer.borderColor = UIColor(named: "GreyColor")!.cgColor
                
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
        
        workHouseText.translatesAutoresizingMaskIntoConstraints = false
        let workHouseTextConstraints = [
            workHouseText.topAnchor.constraint(equalTo: workHouseTitle.bottomAnchor, constant: 5),
            workHouseText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            workHouseText.widthAnchor.constraint(equalToConstant: 200),
            workHouseText.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        billTitle.translatesAutoresizingMaskIntoConstraints = false
        let billTitleConstraints = [
            billTitle.topAnchor.constraint(equalTo: workHouseText.bottomAnchor, constant: 25),
            billTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            billTitle.widthAnchor.constraint(equalToConstant: 200),
            billTitle.heightAnchor.constraint(equalToConstant: 30)
        ]
        
        billPrice.translatesAutoresizingMaskIntoConstraints = false
        let billPriceConstraints = [
            billPrice.topAnchor.constraint(equalTo: billTitle.bottomAnchor, constant: 10),
            billPrice.leftAnchor.constraint(equalTo: billTitle.leftAnchor, constant: 6),
            billPrice.widthAnchor.constraint(equalToConstant: 200),
            billPrice.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        view.addSubview(typeText)
        view.addSubview(nameText)
        view.addSubview(viewRectangle)
        view.addSubview(hideRectangle)
        view.addSubview(descriptionText)
        view.addSubview(workHouseTitle)
        view.addSubview(workHouseText)
        view.addSubview(billTitle)
        view.addSubview(billPrice)
        
        let constraintsArray = [typeTextConstraints, nameTextConstraints, viewRectangleConstraints, hideRectangleConstraints, descriptionTextConstraints, workHouseTitleConstraints, workHouseTextConstraints, billTitleConstraints, billPriceConstraints].flatMap{$0}
        NSLayoutConstraint.activate(constraintsArray)
        
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
        
        var counter: Int = 0
                
        for _ in stride(from: 0, to: price, by: 1) {
            
            let image = UIImageView(image: UIImage(named: "rubleImage"))
            image.tintColor = UIColor(named: "YellowColor")
            
            image.translatesAutoresizingMaskIntoConstraints = false
            let imageConstraints = [
                image.topAnchor.constraint(equalTo: view.topAnchor),
                image.leftAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(25 * counter)),
                image.widthAnchor.constraint(equalToConstant: 20),
                image.heightAnchor.constraint(equalToConstant: 20)
            ]
            
            view.addSubview(image)
            NSLayoutConstraint.activate(imageConstraints)
            counter += 1
        }
        
        for _ in stride(from: 0, to: 5 - price, by: 1) {
            let image = UIImageView(image: UIImage(named: "rubleImage"))
            image.tintColor = UIColor(named: "LightGrayColor")
            
            image.translatesAutoresizingMaskIntoConstraints = false
            let imageConstraints = [
                image.topAnchor.constraint(equalTo: view.topAnchor),
                image.leftAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(25 * counter)),
                image.widthAnchor.constraint(equalToConstant: 20),
                image.heightAnchor.constraint(equalToConstant: 20)
            ]
            
            view.addSubview(image)
            NSLayoutConstraint.activate(imageConstraints)
            counter += 1
        }
        return view
        
    }
}
