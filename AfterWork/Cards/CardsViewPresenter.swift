//
//  CardsViewPresenter.swift
//  AfterWork
//
//  Created by Евгений Парфененков on 15.03.2023.
//

import Foundation
import UIKit
import MapKit

class CardsViewPresenter {
    
    private let controller = DI.shared.getCardsViewController()

    
    func goToMain() {
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        sceneDelegate.window!.rootViewController?.dismiss(animated: true)
        
        self.controller.dismiss(animated: true)
    }
    
    
    func setUpLocation(locationManager: CLLocationManager) {
        
        DispatchQueue.background(background: { 
            if (CLLocationManager.locationServicesEnabled()) {
                
                locationManager.requestAlwaysAuthorization()
                locationManager.startUpdatingLocation()
            }
        })
        
    }
    static var isSearching: Bool = false
    static func getCards() -> Array<Array<Any>>? {
        if isSearching {
            DI.poiData.placesListSearch?.insert([1, "Инструкция", "Что это такое?", "Some address", 57.2965039, 47.9360589, "Смахнешь влево - получишь карточки, смахнешь вправо - отдохни на браво. А карточки с подсветкой - наши избранные, имей ввиду", false, 4, "+79991234060", "12:00 - 22:00"] as [Any], at: 0)
            return DI.poiData.placesListSearch
        } else {
            return DI.poiData.placesList
        }
        
    }
}
