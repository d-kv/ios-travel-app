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
    static func getCards() -> [Places]? {
        if isSearching {
            DataLoaderImpl.shared.placesSearch.insert(Places(id: 0, yaid: 0, category: String(localized: "instruction_title"), name: String(localized: "instruction_desc"), url: "", latitude: "", longitude: "", address: "", description: String(localized: "instruction_text"), isRecommended: false, phone: "", availability: ""), at: 0)
            return DataLoaderImpl.shared.placesSearch
        } else {
            return DataLoaderImpl.shared.places
        }
        
    }
}
