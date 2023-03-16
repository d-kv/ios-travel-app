//
//  MapViewController.swift
//  Tinkoff Travel
//
//  Created by Евгений Парфененков on 02.03.2023.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    let backButton = UIButton()
    let mapView = MKMapView()
    
    var locationManager: CLLocationManager!
    
    var setRegionFlag = true
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.11, longitudeDelta: 0.11))
        
        if setRegionFlag {
            mapView.setRegion(region, animated: false)
            setRegionFlag = !setRegionFlag
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        DispatchQueue.background(background: { [self] in
            if (CLLocationManager.locationServicesEnabled()) {
                
                locationManager.requestAlwaysAuthorization()
                locationManager.startUpdatingLocation()
            }
        })
        
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTap), for: .touchUpInside)

        mapView.register(
          ArtworkView.self,
          forAnnotationViewWithReuseIdentifier:
            MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        let artwork = Artwork(
            title: "King David Kalakaua",
            locationName: "Waikiki Gateway Park",
            discipline: "Sculpture",
            coordinate: CLLocationCoordinate2D(latitude: 56.2965039, longitude: 43.9360589),
            image: UIImage(named: "markerTop")
        )
    
        mapView.addAnnotation(artwork)
        mapView.showsUserLocation = true
                
        setUpConstraints()
    }
    
    
    func setUpConstraints() {
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        let mapViewConstraints = [
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ]
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        let backButtonConstraints = [
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            backButton.widthAnchor.constraint(equalToConstant: 50),
            backButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        view.addSubview(mapView)
        view.addSubview(backButton)
        
        let constraintsArray = [mapViewConstraints, backButtonConstraints].flatMap{$0}
        NSLayoutConstraint.activate(constraintsArray)
    }
    
    @objc func backButtonTap() {
        MapViewPresenter.goToMain()
    }
}

private extension MKMapView {
    func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
    ) {
    let coordinateRegion = MKCoordinateRegion(
        center: location.coordinate,
        latitudinalMeters: regionRadius,
        longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}

extension MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, annotationView view: ArtworkView,
        calloutAccessoryControlTapped control: UIControl) {
            guard let artwork = view.annotation as? Artwork else {
                return
            }

            let launchOptions = [
                MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
            ]
        
            artwork.mapItem?.openInMaps(launchOptions: launchOptions)
        }
}

extension MapViewController: MKMapViewDelegate {

   func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
       //print("calloutAccessoryControlTapped")
       let launchOptions = [
           MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
         ]
       
       guard let artwork = view.annotation as? Artwork else {
           return
         }
       artwork.mapItem?.openInMaps(launchOptions: launchOptions)
    
   }

   func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
      //print("didSelectAnnotationTapped")
   }
}
