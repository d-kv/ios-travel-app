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
    
    func goToDesc(type: String, name: String, description: String, workHours: String, contacts: String, bill: Int, artwork: Artwork, currentCoords: CLLocationCoordinate2D, isRecommended: Bool) {
        // todo
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            let mapDescViewController = DI.shared.getMapDescViewController()
            mapDescViewController.titleText.text = type
            mapDescViewController.titleText.setLineSpacing(lineSpacing: 0, lineHeightMultiple: 0.6)
            mapDescViewController.nameText.text = name
            mapDescViewController.nameText.setLineSpacing(lineSpacing: 0, lineHeightMultiple: 0.6)
            mapDescViewController.descriptionText.text = description
            mapDescViewController.descriptionText.setLineSpacing(lineSpacing: 0, lineHeightMultiple: 1)
            mapDescViewController.workHoursText.text = workHours
            //mapDescViewController.contactsText.text = contacts
            mapDescViewController.contactsText.setTitle(contacts, for: .normal)
            mapDescViewController.billText = DI.shared.getInterfaceExt().worstPrice(price: bill)
            mapDescViewController.artwork = artwork
            mapDescViewController.currentCoordinate = currentCoords
            mapDescViewController.isRecomended = isRecommended
            
            topController.present(mapDescViewController, animated: true, completion: nil)
            
        }
    }
    
    static func setUpLocation(locationManager: CLLocationManager) {
        DispatchQueue.background(background: {
            if (CLLocationManager.locationServicesEnabled()) {
                
                locationManager.requestAlwaysAuthorization()
                locationManager.startUpdatingLocation()
            }
        })
    }
    
    static func setUpPoints(mapView: MKMapView, category: String, isRecommended: Bool) {
        UIView.animate(withDuration: 1) { mapView.removeAnnotations(mapView.annotations) }
        
        
        for i in DI.poiData.placesList! {
            var image = UIImage(named: "marker")
            if i[7] as! Bool {
                image = UIImage(named: "markerTop")
            }
            let artwork = Artwork(
                title: i[2] as? String,
                locationName: i[1] as? String,
                discipline: "\(i[0])",
                coordinate: CLLocationCoordinate2D(latitude: i[4] as! CLLocationDegrees, longitude: i[5] as! CLLocationDegrees),
                image: image
            )
                        
            if !(i[1] as! String).isEqual("Инструкция") {
                
                let catCafe = ["bars", "cafe", "fast food", "restaurants", "sushi"]
                let catArt = ["museum", "spa", "malls", "fallback services", "confectionary", "concert hall", "bars"]
                let catHotel = ["hotels"]
                
                UIView.animate(withDuration: 0.3) {
                    switch category {
                    case "all":
                        if isRecommended && (i[7] as! Bool) { mapView.addAnnotation(artwork) }
                        else if !isRecommended { mapView.addAnnotation(artwork) }
                    case "food":
                        if isRecommended && (i[7] as! Bool) && catCafe.contains(i[1] as! String) { mapView.addAnnotation(artwork) }
                        else if !isRecommended && catCafe.contains(i[1] as! String) { mapView.addAnnotation(artwork) }
                        if isRecommended && (i[7] as! Bool) && i[2] as? String == "Lee' Food" {print("Selected")}
                    case "art":
                        if isRecommended && (i[7] as! Bool) && catArt.contains(i[1] as! String) { mapView.addAnnotation(artwork) }
                        else if !isRecommended && catArt.contains(i[1] as! String) { mapView.addAnnotation(artwork) }
                    case "hotel":
                        if isRecommended && (i[7] as! Bool) && catHotel.contains(i[1] as! String) { mapView.addAnnotation(artwork) }
                        else if !isRecommended && catHotel.contains(i[1] as! String) { mapView.addAnnotation(artwork) }

                    default:
                        if isRecommended && (i[7] as! Bool) {
                            print("selected", i[1] as! String, catCafe.contains(i[1] as! String), i[7] as! Bool)
                        }
                    }
                }
            }
            
        }
        
    }
}
