//
//  MapViewController.swift
//  Tinkoff Travel
//
//  Created by Евгений Парфененков on 02.03.2023.
//

import Foundation
import UIKit
import MapKit

//let interfaceExt = DI.container.resolve(InterfaceExt.self)!
class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // MARK: - Main
    
    let mapViewPresenter: MapViewPresenter = MapViewPresenter()
        
    let backButton = UIButton()
    let mapView = MKMapView()
    
    let taxiButton = DI.shared.getInterfaceExt().standardButton(title: String(localized: "map_taxi"), backgroundColor: UIColor(named: "YellowColor")!, cornerRadius: 15, titleColor: UIColor(named: "GreyColor")!, font: .systemFont(ofSize: 16))
    let wayButton = DI.shared.getInterfaceExt().standardButton(title: String(localized: "map_path"), backgroundColor: UIColor(named: "LightGrayColor")!, cornerRadius: 15, titleColor: .white, font: .systemFont(ofSize: 16))
    
    let recomendButton = UIButton()
    let segmentControl = UISegmentedControl(items: ["Все", "Еда", "Досуг", "Отель"])
    
    var locationManager: CLLocationManager!
    
    var anotherStart: CLLocationCoordinate2D!
    var anotherEnd: CLLocationCoordinate2D!
    
    var targetPoint: Artwork!
    
    static var isSearching: Bool = false
        
    var setRegionFlag = true
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.11, longitudeDelta: 0.11))
        
        if setRegionFlag && targetPoint == nil {
            mapView.setRegion(region, animated: false)
            setRegionFlag = !setRegionFlag
        }
        
    }
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapViewPresenter.delegate = self
        
        mapView.delegate = self
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        MapViewPresenter.setUpLocation(locationManager: locationManager)
        
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        
        backButton.addTarget(self, action: #selector(backButtonTap), for: .touchUpInside)
        taxiButton.addTarget(self, action: #selector(taxiButtonTap), for: .touchUpInside)
        wayButton.addTarget(self, action: #selector(wayButtonTap), for: .touchUpInside)
        
        setUpSegment()

        mapView.register(
          ArtworkView.self,
          forAnnotationViewWithReuseIdentifier:
            MKMapViewDefaultAnnotationViewReuseIdentifier)
        
//        let artwork = Artwork(
//            title: "King David Kalakaua",
//            locationName: "Waikiki Gateway Park",
//            discipline: "Sculpture",
//            coordinate: CLLocationCoordinate2D(latitude: 56.2965039, longitude: 43.9360589),
//            image: UIImage(named: "markerTop")
//        )
        
        if targetPoint != nil {
            
            let a = targetPoint.coordinate
            //let b = mapView.userLocation.coordinate
            //let apoint = MKMapPoint(a)
            //let bpoint = MKMapPoint(b)
            mapView.addAnnotation(targetPoint)
            segmentControl.isHidden = true
            recomendButton.isHidden = true
            
            mapView.centerToLocation(CLLocation(latitude: a.latitude, longitude: a.longitude), regionRadius: CLLocationDistance(10000))
        } else {
            //mapView.addAnnotation(artwork)
            MapViewPresenter.setUpPoints(mapView: mapView, category: "all", isRecommended: false, isSearching: MapViewController.isSearching)
            taxiButton.isHidden = true
            wayButton.isHidden = true
        }
            
        mapView.showsUserLocation = true
                
        setUpConstraints()
    }
    
    // MARK: - Constraints
    
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
        
        taxiButton.translatesAutoresizingMaskIntoConstraints = false
        let taxiButtonConstraints = [
            taxiButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            taxiButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            taxiButton.heightAnchor.constraint(equalToConstant: 50),
            taxiButton.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -10)
        ]
        
        wayButton.translatesAutoresizingMaskIntoConstraints = false
        let wayButtonConstraints = [
            wayButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            wayButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            wayButton.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            wayButton.heightAnchor.constraint(equalToConstant: 50),
        ]
        
        recomendButton.translatesAutoresizingMaskIntoConstraints = false
        let recomendButtonConstraints = [
            recomendButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            recomendButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            //recomendButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            recomendButton.heightAnchor.constraint(equalToConstant: 50),
            recomendButton.widthAnchor.constraint(equalToConstant: 50)
        ]
        
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        let segmentControlConstraints = [
            segmentControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            segmentControl.rightAnchor.constraint(equalTo: recomendButton.leftAnchor, constant: -10),
            segmentControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            segmentControl.heightAnchor.constraint(equalToConstant: 50),
        ]
        
        view.addSubview(mapView)
        view.addSubview(backButton)
        view.addSubview(taxiButton)
        view.addSubview(wayButton)
        view.addSubview(recomendButton)
        view.addSubview(segmentControl)
        
        let constraintsArray = [mapViewConstraints, backButtonConstraints, taxiButtonConstraints, wayButtonConstraints, recomendButtonConstraints, segmentControlConstraints].flatMap{$0}
        NSLayoutConstraint.activate(constraintsArray)
    }
    
    func setUpSegment() {
        recomendButton.backgroundColor = UIColor(named: "LightGrayColor")
        recomendButton.layer.cornerRadius = 10
        recomendButton.setImage(UIImage(named: "starImage")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        recomendButton.addTarget(self, action: #selector(recomendTap), for: .touchUpInside)
        
        segmentControl.selectedSegmentTintColor = UIColor(named: "LightGrayColor")
        segmentControl.selectedSegmentIndex = 0
        segmentControl.backgroundColor = .white
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor(named: "LightGrayColor")!], for: .normal)
        segmentControl.layer.cornerRadius = 50
        segmentControl.layer.masksToBounds = true
        segmentControl.clipsToBounds = true
        segmentControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            if self.segmentControl.backgroundColor == .white { MapViewPresenter.setUpPoints(mapView: self.mapView, category: "all", isRecommended: false, isSearching: MapViewController.isSearching) }
            else { MapViewPresenter.setUpPoints(mapView: self.mapView, category: "all", isRecommended: true, isSearching: MapViewController.isSearching) }
        case 1:
            if self.segmentControl.backgroundColor == .white { MapViewPresenter.setUpPoints(mapView: self.mapView, category: "food", isRecommended: false, isSearching: MapViewController.isSearching) }
            else { MapViewPresenter.setUpPoints(mapView: self.mapView, category: "food", isRecommended: true, isSearching: MapViewController.isSearching) }
        case 2:
            if self.segmentControl.backgroundColor == .white { MapViewPresenter.setUpPoints(mapView: self.mapView, category: "art", isRecommended: false, isSearching: MapViewController.isSearching) }
            else { MapViewPresenter.setUpPoints(mapView: self.mapView, category: "art", isRecommended: true, isSearching: MapViewController.isSearching) }
        case 3:
            if self.segmentControl.backgroundColor == .white { MapViewPresenter.setUpPoints(mapView: self.mapView, category: "hotel", isRecommended: false, isSearching: MapViewController.isSearching) }
            else { MapViewPresenter.setUpPoints(mapView: self.mapView, category: "hotel", isRecommended: true, isSearching: MapViewController.isSearching) }
        default:
            print("aaa")
        }

    }
    
    @objc func recomendTap() {
        UIView.animate(withDuration: 0.3) {
            if self.segmentControl.backgroundColor == .white {
                switch self.segmentControl.selectedSegmentIndex {
                case 0:
                    MapViewPresenter.setUpPoints(mapView: self.mapView, category: "all", isRecommended: true, isSearching: MapViewController.isSearching)
                case 1:
                    MapViewPresenter.setUpPoints(mapView: self.mapView, category: "food", isRecommended: true, isSearching: MapViewController.isSearching)
                case 2:
                    MapViewPresenter.setUpPoints(mapView: self.mapView, category: "art", isRecommended: true, isSearching: MapViewController.isSearching)
                case 3:
                    MapViewPresenter.setUpPoints(mapView: self.mapView, category: "hotel", isRecommended: true, isSearching: MapViewController.isSearching)
                default:
                    print("aa")
                }
                
                self.recomendButton.setImage(UIImage(named: "starImage")?.withTintColor(UIColor(named: "YellowColor")!, renderingMode: .alwaysOriginal), for: .normal)
                self.segmentControl.selectedSegmentTintColor = UIColor(named: "YellowColor")
                self.segmentControl.backgroundColor = UIColor(named: "GreyColor")
                self.segmentControl.setTitleTextAttributes([.foregroundColor: UIColor(named: "GreyColor")!], for: .selected)
                self.segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)

            } else {
                switch self.segmentControl.selectedSegmentIndex {
                case 0:
                    MapViewPresenter.setUpPoints(mapView: self.mapView, category: "all", isRecommended: false, isSearching: MapViewController.isSearching)
                case 1:
                    MapViewPresenter.setUpPoints(mapView: self.mapView, category: "food", isRecommended: false, isSearching: MapViewController.isSearching)
                case 2:
                    MapViewPresenter.setUpPoints(mapView: self.mapView, category: "art", isRecommended: false, isSearching: MapViewController.isSearching)
                case 3:
                    MapViewPresenter.setUpPoints(mapView: self.mapView, category: "hotel", isRecommended: false, isSearching: MapViewController.isSearching)
                default:
                    print("aa")
                }
                
                self.recomendButton.setImage(UIImage(named: "starImage")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
                self.segmentControl.selectedSegmentTintColor = UIColor(named: "LightGrayColor")
                self.segmentControl.backgroundColor = .white
                self.segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
                self.segmentControl.setTitleTextAttributes([.foregroundColor: UIColor(named: "LightGrayColor")!], for: .normal)

            }
        }
        
    }
    
    // MARK: - Button Tap
    
    @objc func backButtonTap() {
        MapViewPresenter.goToMain()
    }
    
    @objc func taxiButtonTap() {
        let start = mapView.userLocation.coordinate
        let end = targetPoint.coordinate
        let defaultWebsiteURL = URL(string: "https://3.redirect.appmetrica.yandex.com/route?start-lat=" + String(start.latitude) + "&start-lon=" + String(start.longitude) + "&end-lat=" + String(end.latitude) + "&end-lon=" + String(end.longitude) + "&level=50&appmetrica_tracking_id=1178268795219780156")!
        
        UIApplication.shared.open(defaultWebsiteURL)
    }
    
    @objc func wayButtonTap() {
        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
        ]
        targetPoint.mapItem?.openInMaps(launchOptions: launchOptions)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let artwork = view.annotation as? Artwork else {
            return
        }
        if targetPoint == nil {
            let currentData = DI.poiData.placesList?.filter { $0[0] as? Int == Int(artwork.discipline!)}[0]
            
            DI.shared.getMapViewPresenter().goToDesc(type: currentData![1] as! String, name: currentData![2] as! String, description: currentData![6] as! String, workHours: currentData![10] as! String, contacts: currentData![9] as! String, bill: currentData![8] as! Int, artwork: artwork, currentCoords: mapView.userLocation.coordinate, isRecommended: currentData![7] as! Bool)
        }
     
     }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        //print("didSelectAnnotationTapped")
        //print("ZHOPA1")
        
    }
    
    func makeRect(coordinates:[CLLocationCoordinate2D]) -> MKMapRect {
        var rect = MKMapRect()
        var coordinates = coordinates
        if !coordinates.isEmpty {
            let first = coordinates.removeFirst()
            var top = first.latitude
            var bottom = first.latitude
            var left = first.longitude
            var right = first.longitude
            coordinates.forEach { coordinate in
                top = max(top, coordinate.latitude)
                bottom = min(bottom, coordinate.latitude)
                left = min(left, coordinate.longitude)
                right = max(right, coordinate.longitude)
            }
            let topLeft = MKMapPoint(CLLocationCoordinate2D(latitude:top, longitude:left))
            let bottomRight = MKMapPoint(CLLocationCoordinate2D(latitude:bottom, longitude:right))
            rect = MKMapRect(x:topLeft.x, y:topLeft.y,
                             width:bottomRight.x - topLeft.x, height:bottomRight.y - topLeft.y)
        }
        return rect
    }
}

// MARK: - Extensions

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

extension MapViewController: MapViewPresenterDelegate {
    func switchedPoint(target: Artwork, isSwitched: Bool) {
        // do nothing
    }
}
