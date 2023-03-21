//
//  MapViewPresenter.swift
//  Tinkoff Travel
//
//  Created by Евгений Парфененков on 02.03.2023.
//

import Foundation
import UIKit
import MapKit

protocol MapViewPresenterDelegate: AnyObject {
    func switchedPoint(target: Artwork, isSwitched: Bool)
}


final class MapViewPresenter {
    
    weak var delegate: MapViewPresenterDelegate?
    
    static func goToMain() {
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        sceneDelegate.window!.rootViewController?.dismiss(animated: true)
        //sceneDelegate.window!.rootViewController?.present(mainViewController, animated: true)
        
    }
    
    func calculateDistance(mapView: MKMapView) {
        
        delegate?.switchedPoint(target: mapView.annotations[0] as! Artwork, isSwitched: true)
        NSLog("Target1", 1)
    }
    
    static func setUpLocation(locationManager: CLLocationManager) {
        DispatchQueue.background(background: {
            if (CLLocationManager.locationServicesEnabled()) {
                
                locationManager.requestAlwaysAuthorization()
                locationManager.startUpdatingLocation()
            }
        })
    }
    
    static func setUpPoints(mapView: MKMapView) {
        
        for i in DI.poiData.placesList! {
            var image = UIImage(named: "marker")
            if i[7] as! Bool {
                image = UIImage(named: "markerTop")
            }
            
            let artwork = Artwork(
                title: i[2] as? String,
                locationName: i[1] as? String,
                discipline: i[1] as? String,
                coordinate: CLLocationCoordinate2D(latitude: i[4] as! CLLocationDegrees, longitude: i[5] as! CLLocationDegrees),
                image: image
            )
            
            if !(i[1] as! String).isEqual("Инструкция") {
                mapView.addAnnotation(artwork)
            }
            
        }
        
    }
    
}
