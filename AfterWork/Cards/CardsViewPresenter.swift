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
    
    
//    var locationManager: CLLocationManager!
//
//    var setRegionFlag = true
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        let location = locations.last! as CLLocation
//
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate. longitude)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.11, longitudeDelta: 0.11))
//
//        if setRegionFlag {
//            mapView.setRegion(region, animated: false)
//            setRegionFlag = !setRegionFlag
//        }
//
//    }
    
    static func goToMain() {
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        sceneDelegate.window!.rootViewController?.dismiss(animated: true)
    }
    
}
