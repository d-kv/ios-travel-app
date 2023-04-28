//
//  MapViewController.swift
//  Tinkoff Travel
//
//  Created by Евгений Парфененков on 02.03.2023.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    // MARK: - Main

    let mapViewPresenter: MapViewPresenter = MapViewPresenter()

    let backButton = UIButton()
    let mapView = MKMapView()

    let taxiButton = DI.shared.getInterfaceExt().standardButton(
        title: String(localized: "map_taxi"),
        backgroundColor: UIColor(named: "YellowColor") ?? .yellow,
        cornerRadius: 15, titleColor: UIColor(named: "GreyColor") ?? .white,
        font: .systemFont(ofSize: 16)
    )
    let wayButton = DI.shared.getInterfaceExt().standardButton(
        title: String(localized: "map_path"),
        backgroundColor: UIColor(named: "LightGrayColor") ?? .white,
        cornerRadius: 15, titleColor: .white,
        font: .systemFont(ofSize: 16)
    )

    let recommendButton = UIButton()
    let segmentControl = UISegmentedControl(items: ["Все", "Еда", "Досуг", "Отель"])

    var locationManager: CLLocationManager?

    var anotherStart: CLLocationCoordinate2D?
    var anotherEnd: CLLocationCoordinate2D?

    var targetPoint: Artwork?

    static var isSearching: Bool = false

    var setRegionFlag = true
    
    

    // MARK: - ViewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapViewPresenter.delegate = self
        mapView.delegate = self
        
        let location = currentLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.11, longitudeDelta: 0.11))
        if setRegionFlag && targetPoint == nil {
            mapView.setRegion(region, animated: false)
            setRegionFlag = !setRegionFlag
        }
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)

        backButton.addTarget(self, action: #selector(backButtonTap), for: .touchUpInside)
        taxiButton.addTarget(self, action: #selector(taxiButtonTap), for: .touchUpInside)
        wayButton.addTarget(self, action: #selector(wayButtonTap), for: .touchUpInside)

        setUpSegment()

        mapView.register(
          ArtworkView.self,
          forAnnotationViewWithReuseIdentifier:
            MKMapViewDefaultAnnotationViewReuseIdentifier)

        if targetPoint != nil {

            let a = targetPoint?.coordinate

            mapView.addAnnotation(targetPoint ?? Artwork(title: "", locationName: "", discipline: "", coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), image: .add))
            segmentControl.isHidden = true
            recommendButton.isHidden = true

            mapView.centerToLocation(CLLocation(latitude: a?.latitude ?? CLLocationDegrees(0), longitude: a?.longitude ?? CLLocationDegrees(0)), regionRadius: CLLocationDistance(10000))
        } else {
            MapViewPresenter.setUpPoints(mapView: mapView, category: .all, isRecommended: false, isSearching: MapViewController.isSearching)
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
            wayButton.heightAnchor.constraint(equalToConstant: 50)
        ]

        recommendButton.translatesAutoresizingMaskIntoConstraints = false
        let recommendButtonConstraints = [
            recommendButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            recommendButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            recommendButton.heightAnchor.constraint(equalToConstant: 50),
            recommendButton.widthAnchor.constraint(equalToConstant: 50)
        ]

        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        let segmentControlConstraints = [
            segmentControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            segmentControl.rightAnchor.constraint(equalTo: recommendButton.leftAnchor, constant: -10),
            segmentControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            segmentControl.heightAnchor.constraint(equalToConstant: 50)
        ]

        view.addSubview(mapView)
        view.addSubview(backButton)
        view.addSubview(taxiButton)
        view.addSubview(wayButton)
        view.addSubview(recommendButton)
        view.addSubview(segmentControl)

        let constraintsArray = [mapViewConstraints, backButtonConstraints, taxiButtonConstraints, wayButtonConstraints, recommendButtonConstraints, segmentControlConstraints].flatMap {$0}
        NSLayoutConstraint.activate(constraintsArray)
    }

    func setUpSegment() {
        recommendButton.backgroundColor = UIColor(named: "LightGrayColor")
        recommendButton.layer.cornerRadius = 10
        recommendButton.setImage(UIImage(named: "starImage")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        recommendButton.addTarget(self, action: #selector(recommendTap), for: .touchUpInside)

        segmentControl.selectedSegmentTintColor = UIColor(named: "LightGrayColor")
        segmentControl.selectedSegmentIndex = 0
        segmentControl.backgroundColor = .white
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor(named: "LightGrayColor") ?? .white], for: .normal)
        segmentControl.layer.cornerRadius = 50
        segmentControl.layer.masksToBounds = true
        segmentControl.clipsToBounds = true
        segmentControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }

    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case segment.all.rawValue:
            if self.segmentControl.backgroundColor == .white {
                MapViewPresenter.setUpPoints(mapView: self.mapView, category: .all, isRecommended: false, isSearching: MapViewController.isSearching)
            }
            else { MapViewPresenter.setUpPoints(mapView: self.mapView, category: .all, isRecommended: true, isSearching: MapViewController.isSearching) }
        case segment.food.rawValue:
            if self.segmentControl.backgroundColor == .white {
                MapViewPresenter.setUpPoints(mapView: self.mapView, category: .food, isRecommended: false, isSearching: MapViewController.isSearching)
            }
            else { MapViewPresenter.setUpPoints(mapView: self.mapView, category: .food, isRecommended: true, isSearching: MapViewController.isSearching) }
        case segment.art.rawValue:
            if self.segmentControl.backgroundColor == .white {
                MapViewPresenter.setUpPoints(mapView: self.mapView, category: .art, isRecommended: false, isSearching: MapViewController.isSearching)
            }
            else { MapViewPresenter.setUpPoints(mapView: self.mapView, category: .art, isRecommended: true, isSearching: MapViewController.isSearching) }
        case segment.hotel.rawValue:
            if self.segmentControl.backgroundColor == .white {
                MapViewPresenter.setUpPoints(mapView: self.mapView, category: .hotel, isRecommended: false, isSearching: MapViewController.isSearching)
            }
            else { MapViewPresenter.setUpPoints(mapView: self.mapView, category: .hotel, isRecommended: true, isSearching: MapViewController.isSearching) }
        default:
            print("")
        }

        enum segment: Int {
            case all = 0
            case food = 1
            case art = 2
            case hotel = 3
        }

    }

    @objc func recommendTap() {
        UIView.animate(withDuration: 0.3) {
            if self.segmentControl.backgroundColor == .white {
                switch self.segmentControl.selectedSegmentIndex {
                case segment.all.rawValue:
                    MapViewPresenter.setUpPoints(mapView: self.mapView, category: .all, isRecommended: true, isSearching: MapViewController.isSearching)
                case segment.food.rawValue:
                    MapViewPresenter.setUpPoints(mapView: self.mapView, category: .food, isRecommended: true, isSearching: MapViewController.isSearching)
                case segment.art.rawValue:
                    MapViewPresenter.setUpPoints(mapView: self.mapView, category: .art, isRecommended: true, isSearching: MapViewController.isSearching)
                case segment.hotel.rawValue:
                    MapViewPresenter.setUpPoints(mapView: self.mapView, category: .hotel, isRecommended: true, isSearching: MapViewController.isSearching)
                default:
                    print("")
                }

                self.recommendButton.setImage(UIImage(named: "starImage")?.withTintColor(UIColor(named: "YellowColor") ?? .yellow, renderingMode: .alwaysOriginal), for: .normal)
                self.segmentControl.selectedSegmentTintColor = UIColor(named: "YellowColor")
                self.segmentControl.backgroundColor = UIColor(named: "GreyColor")
                self.segmentControl.setTitleTextAttributes([.foregroundColor: UIColor(named: "GreyColor") ?? .yellow], for: .selected)
                self.segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)

            } else {
                switch self.segmentControl.selectedSegmentIndex {
                case segment.all.rawValue:
                    MapViewPresenter.setUpPoints(mapView: self.mapView, category: .all, isRecommended: false, isSearching: MapViewController.isSearching)
                case segment.food.rawValue:
                    MapViewPresenter.setUpPoints(mapView: self.mapView, category: .food, isRecommended: false, isSearching: MapViewController.isSearching)
                case segment.art.rawValue:
                    MapViewPresenter.setUpPoints(mapView: self.mapView, category: .art, isRecommended: false, isSearching: MapViewController.isSearching)
                case segment.hotel.rawValue:
                    MapViewPresenter.setUpPoints(mapView: self.mapView, category: .hotel, isRecommended: false, isSearching: MapViewController.isSearching)
                default:
                    print("")
                }

                self.recommendButton.setImage(UIImage(named: "starImage")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
                self.segmentControl.selectedSegmentTintColor = UIColor(named: "LightGrayColor")
                self.segmentControl.backgroundColor = .white
                self.segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
                self.segmentControl.setTitleTextAttributes([.foregroundColor: UIColor(named: "LightGrayColor") ?? .white], for: .normal)

            }
        }

        enum segment: Int {
            case all = 0
            case food = 1
            case art = 2
            case hotel = 3
        }

    }

    // MARK: - Button Tap

    @objc func backButtonTap() {
        MapViewPresenter.goToMain()
    }

    @objc func taxiButtonTap() {
        let start = mapView.userLocation.coordinate
        let end = targetPoint?.coordinate
        let defaultWebsiteURL = URL(string: "https://3.redirect.appmetrica.yandex.com/route?start-lat=" + String(start.latitude) + "&start-lon=" + String(start.longitude) + "&end-lat=" + String(end?.latitude ?? CLLocationDegrees(0)) + "&end-lon=" + String(end?.longitude ?? CLLocationDegrees(0)) + "&level=50&appmetrica_tracking_id=1178268795219780156")!

        UIApplication.shared.open(defaultWebsiteURL)
    }

    @objc func wayButtonTap() {
        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ]
        targetPoint?.mapItem?.openInMaps(launchOptions: launchOptions)
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let artwork = view.annotation as? Artwork else {
            return
        }
        if targetPoint == nil {
            let currentData = DataLoaderImpl.shared.places.filter { $0.id == Int(artwork.discipline ?? "") }[0]

            DI.shared.getMapViewPresenter().goToDesc(
                type: currentData.category, name: currentData.name, description: currentData.description,
                workHours: currentData.availability, contacts: currentData.phone, url: currentData.url,
                artwork: artwork, currentCoords: mapView.userLocation.coordinate,
                isRecommended: currentData.isRecommended
            )
        }

     }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // print("didSelectAnnotationTapped")

    }

    func makeRect(coordinates: [CLLocationCoordinate2D]) -> MKMapRect {
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
            let topLeft = MKMapPoint(CLLocationCoordinate2D(latitude: top, longitude: left))
            let bottomRight = MKMapPoint(CLLocationCoordinate2D(latitude: bottom, longitude: right))
            rect = MKMapRect(x: topLeft.x, y: topLeft.y,
                             width: bottomRight.x - topLeft.x, height: bottomRight.y - topLeft.y)
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
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ]

        artwork.mapItem?.openInMaps(launchOptions: launchOptions)
    }
}

extension MapViewController: MapViewPresenterDelegate {
    func switchedPoint(target: Artwork, isSwitched: Bool) {
        // do nothing
    }
}
