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

    }

    func calculateDistance(mapView: MKMapView) {

        delegate?.switchedPoint(
            target: mapView.annotations[0] as? Artwork ?? Artwork(
                title: "", locationName: "", discipline: "",
                coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0),
                image: .add
            ),
            isSwitched: true
        )
    }

    func goToDesc(type: String, name: String, description: String, workHours: String, contacts: String, url: String, artwork: Artwork, currentCoords: CLLocationCoordinate2D, isRecommended: Bool) {
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
            mapDescViewController.contactsText.setTitle(contacts, for: .normal)
            mapDescViewController.urlText.setTitle(url, for: .normal)
            mapDescViewController.artwork = artwork
            mapDescViewController.currentCoordinate = currentCoords
            mapDescViewController.isRecommended = isRecommended

            topController.present(mapDescViewController, animated: true, completion: nil)

        }
    }

    static func setUpLocation(locationManager: CLLocationManager) {
        DispatchQueue.background(background: {
            if CLLocationManager.locationServicesEnabled() {

                locationManager.requestAlwaysAuthorization()
                locationManager.startUpdatingLocation()
            }
        })
    }

    enum categories {
        case all
        case food
        case art
        case hotel
    }

    static func setUpPoints(mapView: MKMapView, category: categories, isRecommended: Bool, isSearching: Bool) {

        var tempData = DataLoaderImpl.shared.places
        if isSearching { tempData = DataLoaderImpl.shared.placesSearch }

        for i in tempData {
            var image = UIImage(named: "marker")
            if i.isRecommended {
                image = UIImage(named: "markerTop")
            }

            let coordinate = CLLocationCoordinate2D(latitude: Double(i.latitude) ?? 0, longitude: Double(i.longitude) ?? 0)
            let artwork = Artwork(
                title: i.name,
                locationName: i.category,
                discipline: "\(i.id)",
                coordinate: coordinate,
                image: image
            )

            if !(i.name).isEqual("Инструкция") {

                let catCafe = ["bars", "cafe", "fast food", "restaurants", "sushi"]
                let catArt = ["museum", "spa", "malls", "fallback services", "confectionary", "concert hall", "bars"]
                let catHotel = ["hotels"]

                switch category {
                case .all:
                    if isRecommended && (i.isRecommended) { mapView.addAnnotation(artwork) }
                    else if !isRecommended { mapView.addAnnotation(artwork) }
                case .food:
                    if isRecommended && (i.isRecommended) && catCafe.contains(i.name) { mapView.addAnnotation(artwork) }
                    else if !isRecommended && catCafe.contains(i.name) { mapView.addAnnotation(artwork) }
                case .art:
                    if isRecommended && (i.isRecommended) && catArt.contains(i.name) { mapView.addAnnotation(artwork) }
                    else if !isRecommended && catArt.contains(i.name) { mapView.addAnnotation(artwork) }
                case .hotel:
                    if isRecommended && (i.isRecommended) && catHotel.contains(i.name) { mapView.addAnnotation(artwork) }
                    else if !isRecommended && catHotel.contains(i.name) { mapView.addAnnotation(artwork) }
                }
            }
        }
    }
}
