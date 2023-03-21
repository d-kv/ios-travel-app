//
//  MapViewController.swift
//  Tinkoff Travel
//
//  Created by Евгений Парфененков on 02.03.2023.
//

import Foundation
import MapKit
import UIKit

// MARK: - MapViewController

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
  // MARK: - Main

  let mapViewPresenter: MapViewPresenter = .init()

  let backButton = UIButton()
  let mapView = MKMapView()

  let taxiButton = UIButton()
  let wayButton = UIButton()

  var locationManager: CLLocationManager!

  var anotherStart: CLLocationCoordinate2D!
  var anotherEnd: CLLocationCoordinate2D!

  var targetPoint: Artwork!

  var setRegionFlag = true

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location = locations.last! as CLLocation

    let center = CLLocationCoordinate2D(
      latitude: location.coordinate.latitude,
      longitude: location.coordinate.longitude
    )
    let region = MKCoordinateRegion(
      center: center,
      span: MKCoordinateSpan(latitudeDelta: 0.11, longitudeDelta: 0.11)
    )

    if setRegionFlag && targetPoint == nil {
      mapView.setRegion(region, animated: false)
      setRegionFlag = !setRegionFlag
    }
  }

  // MARK: - ViewDidLoad

  override func viewDidLoad() {
    super.viewDidLoad()

    mapViewPresenter.delegate = self

    mapView.delegate = self

    locationManager = CLLocationManager()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest

    DispatchQueue.background(background: { [self] in
      if CLLocationManager.locationServicesEnabled() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
      }
    })

    backButton.setImage(UIImage(named: "backArrow"), for: .normal)
    backButton.addTarget(self, action: #selector(backButtonTap), for: .touchUpInside)

    taxiButton.setTitle("Такси", for: .normal)
    taxiButton.backgroundColor = UIColor(named: "YellowColor")
    taxiButton.layer.cornerRadius = 15
    taxiButton.setTitleColor(UIColor(named: "GreyColor"), for: .normal)
    taxiButton.titleLabel!.font = UIFont(name: "Helvetica Neue Regular", size: 50)
    taxiButton.addTarget(self, action: #selector(taxiButtonTap), for: .touchUpInside)

    wayButton.setTitle("Маршрут", for: .normal)
    wayButton.backgroundColor = UIColor(named: "LightGrayColor")
    wayButton.layer.cornerRadius = 15
    wayButton.setTitleColor(.white, for: .normal)
    wayButton.titleLabel!.font = UIFont(name: "Helvetica Neue Regular", size: 50)
    wayButton.addTarget(self, action: #selector(wayButtonTap), for: .touchUpInside)

    mapView.register(
      ArtworkView.self,
      forAnnotationViewWithReuseIdentifier:
      MKMapViewDefaultAnnotationViewReuseIdentifier
    )

    let artwork = Artwork(
      title: "King David Kalakaua",
      locationName: "Waikiki Gateway Park",
      discipline: "Sculpture",
      coordinate: CLLocationCoordinate2D(latitude: 56.2965039, longitude: 43.9360589),
      image: UIImage(named: "markerTop")
    )

    if targetPoint != nil {
      mapView.addAnnotation(targetPoint)

      let a = targetPoint.coordinate
      let b = mapView.userLocation.coordinate
      let apoint = MKMapPoint(a)
      let bpoint = MKMapPoint(b)

      mapView.centerToLocation(
        CLLocation(latitude: a.latitude, longitude: a.longitude),
        regionRadius: CLLocationDistance(10000)
      )
    } else {
      mapView.addAnnotation(artwork)
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
      mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
    ]

    backButton.translatesAutoresizingMaskIntoConstraints = false
    let backButtonConstraints = [
      backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
      backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
      backButton.widthAnchor.constraint(equalToConstant: 50),
      backButton.heightAnchor.constraint(equalToConstant: 50),
    ]

    taxiButton.translatesAutoresizingMaskIntoConstraints = false
    let taxiButtonConstraints = [
      taxiButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
      taxiButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
      taxiButton.heightAnchor.constraint(equalToConstant: 50),
      taxiButton.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
    ]

    wayButton.translatesAutoresizingMaskIntoConstraints = false
    let wayButtonConstraints = [
      wayButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
      wayButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
      wayButton.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
      wayButton.heightAnchor.constraint(equalToConstant: 50),
    ]

    view.addSubview(mapView)
    view.addSubview(backButton)
    view.addSubview(taxiButton)
    view.addSubview(wayButton)

    let constraintsArray = [
      mapViewConstraints,
      backButtonConstraints,
      taxiButtonConstraints,
      wayButtonConstraints,
    ].flatMap { $0 }
    NSLayoutConstraint.activate(constraintsArray)
  }

  // MARK: - Button Tap

  @objc
  func backButtonTap() {
    MapViewPresenter.goToMain()
  }

  @objc
  func taxiButtonTap() {
    let start = mapView.userLocation.coordinate
    let end = targetPoint.coordinate
    let defaultWebsiteURL =
      URL(
        string: "https://3.redirect.appmetrica.yandex.com/route?start-lat=" +
          String(start.latitude) + "&start-lon=" + String(start.longitude) + "&end-lat=" +
          String(end.latitude) + "&end-lon=" + String(end.longitude) +
          "&level=50&appmetrica_tracking_id=1178268795219780156"
      )!

    UIApplication.shared.open(defaultWebsiteURL)
  }

  @objc
  func wayButtonTap() {
    let launchOptions = [
      MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
    ]
    targetPoint.mapItem?.openInMaps(launchOptions: launchOptions)
  }

  func mapView(
    _ mapView: MKMapView,
    annotationView view: MKAnnotationView,
    calloutAccessoryControlTapped control: UIControl
  ) {
    // print("calloutAccessoryControlTapped")
    let launchOptions = [
      MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
    ]

    guard let artwork = view.annotation as? Artwork else {
      return
    }
    artwork.mapItem?.openInMaps(launchOptions: launchOptions)
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
      rect = MKMapRect(
        x: topLeft.x,
        y: topLeft.y,
        width: bottomRight.x - topLeft.x,
        height: bottomRight.y - topLeft.y
      )
    }
    return rect
  }
}

// MARK: - Extensions

extension MKMapView {
  fileprivate func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius
    )
    setRegion(coordinateRegion, animated: true)
  }
}

extension MKMapViewDelegate {
  func mapView(
    _ mapView: MKMapView,
    annotationView view: ArtworkView,
    calloutAccessoryControlTapped control: UIControl
  ) {
    guard let artwork = view.annotation as? Artwork else {
      return
    }

    let launchOptions = [
      MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
    ]

    artwork.mapItem?.openInMaps(launchOptions: launchOptions)
  }
}

// MARK: - MapViewController + MapViewPresenterDelegate

extension MapViewController: MapViewPresenterDelegate {
  func switchedPoint(target: Artwork, isSwitched: Bool) {
    NSLog("Target2", 1)
//        mapView.removeAnnotations(mapView.annotations)
//        mapView.addAnnotation(target)
  }
}
