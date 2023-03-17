//
//  CardsViewController.swift
//  AfterWork
//
//  Created by Евгений Парфененков on 15.03.2023.
//

import Foundation
import UIKit
import Shuffle_iOS
import MapKit

class CardsViewController: UIViewController, SwipeCardStackDataSource, SwipeCardStackDelegate, CLLocationManagerDelegate {
    
    let cardStack = SwipeCardStack()
    let backButton = UIButton()
    
    let mapView = MKMapView()
    
    let endText = UITextView()
    
    func numberOfCards(in cardStack: Shuffle_iOS.SwipeCardStack) -> Int { return cards.count }
    
    func didSwipeAllCards(_ cardStack: SwipeCardStack) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.mapView.frame.origin.y = self.view.frame.height + 50
        }, completion: {_ in
            self.mapView.isHidden = true
        })
        
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        if direction == .right  && index != 0 {
            self.dismiss(animated: true)
            
            let mapViewController = MapViewController()
            let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
            sceneDelegate.window!.rootViewController?.present(mapViewController, animated: true)
                        
            let artwork = Artwork(
                title: "King David Kalakaua",
                locationName: "Waikiki Gateway Park",
                discipline: "Sculpture",
                coordinate: CLLocationCoordinate2D(latitude: cards[index + 1][6] as! CLLocationDegrees, longitude: cards[index + 1][7] as! CLLocationDegrees), //cards[0][6]
                image: UIImage(named: "markerTop")
            )
            
            MapViewController.targetPoint = artwork
        }
    }
    
    func cardStack(_ cardStack: Shuffle_iOS.SwipeCardStack, cardForIndexAt index: Int) -> Shuffle_iOS.SwipeCard {
        mapView.removeAnnotations(mapView.annotations)
        
        let artwork = Artwork(
            title: "King David Kalakaua",
            locationName: "Waikiki Gateway Park",
            discipline: "Sculpture",
            coordinate: CLLocationCoordinate2D(latitude: cards[index][6] as! CLLocationDegrees, longitude: cards[index][7] as! CLLocationDegrees), //cards[0][6]
            image: UIImage(named: "markerTop")
        )
        
        mapView.addAnnotation(artwork)
                
        let a = artwork.coordinate
        let b = mapView.userLocation.coordinate
        let apoint = MKMapPoint(a)
        let bpoint = MKMapPoint(b)
        
        //mapView.setVisibleMapRect(MKMapRect(x: min(apoint.x, bpoint.x), y: min(apoint.y, bpoint.y), width: abs(apoint.x - bpoint.x), height: abs(apoint.y - bpoint.y)), animated: true)
        
        mapView.setVisibleMapRect(MKMapRect(x: min(apoint.x, bpoint.x), y: min(apoint.y, bpoint.y), width: abs(apoint.x - bpoint.x), height: abs(apoint.y - bpoint.y)), edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), animated: true)
        return card(fromData: cards[index])
    }
    
    
    let cards = [
        ["Инструкция", "Что это такое?", "Смахнешь влево - получишь карточки, смахнешь вправо - отдохни на браво. А карточки с подсветкой - наши избранные, имей ввиду", "текст", 4, false, 56.2965039, 44.9360589],
        ["Пиццерия", "Papa Jhones", "Третья крупнейшая сеть пиццерий в мире после Pizza Hut и Domino's Pizza, на конец 2018 года сеть Papa John's включала 5303 пиццерии, из них 645 были собственными, остальные работали по франчайзингу", "Ежедневно с 12:00 - 00:00", 4, false, 56.2965039, 44.9360589],
        ["Пиццерия", "Papa Jhones", "Третья крупнейшая сеть пиццерий в мире после Pizza Hut и Domino's Pizza, на конец 2018 года сеть Papa John's включала 5303 пиццерии, из них 645 были собственными, остальные работали по франчайзингу", "Ежедневно с 12:00 - 00:00", 4, false, 55.2965039, 43.9360589],
        ["Пиццерия", "Papa Jhones", "Третья крупнейшая сеть пиццерий в мире после Pizza Hut и Domino's Pizza, на конец 2018 года сеть Papa John's включала 5303 пиццерии, из них 645 были собственными, остальные работали по франчайзингу", "Ежедневно с 12:00 - 00:00", 4, false, 54.2965039, 45.9360589],
        ["Пиццерия", "Papa Jhones", "Третья крупнейшая сеть пиццерий в мире после Pizza Hut и Domino's Pizza, на конец 2018 года сеть Papa John's включала 5303 пиццерии, из них 645 были собственными, остальные работали по франчайзингу", "Ежедневно с 12:00 - 00:00", 4, false, 53.2965039, 47.9360589],
        ["Пиццерия", "Papa Jhones", "Третья крупнейшая сеть пиццерий в мире после Pizza Hut и Domino's Pizza, на конец 2018 года сеть Papa John's включала 5303 пиццерии, из них 645 были собственными, остальные работали по франчайзингу", "Ежедневно с 12:00 - 00:00", 4, false, 52.2965039, 50.9360589],
        ["Пиццерия", "Papa Jhones", "Третья крупнейшая сеть пиццерий в мире после Pizza Hut и Domino's Pizza, на конец 2018 года сеть Papa John's включала 5303 пиццерии, из них 645 были собственными, остальные работали по франчайзингу", "Ежедневно с 12:00 - 00:00", 4, false, 51.2965039, 30.9360589],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardStack.dataSource = self
        cardStack.delegate = self
        view.backgroundColor = .black
        
        mapView.layer.cornerRadius = 23
        mapView.register(ArtworkView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.isUserInteractionEnabled = false
        
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTap), for: .touchUpInside)
        
        endText.text = "Подборка пока что закончилась,\nзагляните позже"
        endText.contentInsetAdjustmentBehavior = .automatic
        endText.adjustsFontForContentSizeCategory = false
        endText.isEditable = false
        endText.sizeToFit()
        endText.isScrollEnabled = false
        endText.isSelectable = false
        
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        let text = NSAttributedString(string: "Подборка пока что закончилась,\nзагляните позже", attributes: [NSAttributedString.Key.paragraphStyle:style, NSAttributedString.Key.font:UIFont(name: "Helvetica Neue", size: 28)!, NSAttributedString.Key.foregroundColor:UIColor(named: "LightGrayColor")!])
        endText.attributedText = text
        
        cardStack.translatesAutoresizingMaskIntoConstraints = false
        let cardStackConstraints = [
            cardStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 130), //150
            cardStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            cardStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
            cardStack.heightAnchor.constraint(equalToConstant: 460) //480
        ]
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        let mapViewConstraints = [
            mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mapView.topAnchor.constraint(equalTo: cardStack.bottomAnchor, constant: 20),
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            mapView.heightAnchor.constraint(equalToConstant: 130),
            
        ]
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        let backButtonConstraints = [
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            backButton.widthAnchor.constraint(equalToConstant: 50),
            backButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        endText.translatesAutoresizingMaskIntoConstraints = false
        let endTextkConstraints = [
            endText.centerXAnchor.constraint(equalTo: cardStack.centerXAnchor),
            endText.centerYAnchor.constraint(equalTo: cardStack.centerYAnchor),
            //endText.topAnchor.constraint(equalTo: view.topAnchor, constant: 130), //150
            endText.heightAnchor.constraint(equalToConstant: 150), //480
            endText.widthAnchor.constraint(equalToConstant: 300)
        ]
        
        view.addSubview(endText)
        
        view.addSubview(mapView)
        
        view.addSubview(cardStack)
        NSLayoutConstraint.activate(cardStackConstraints)
        
        NSLayoutConstraint.activate(mapViewConstraints)
        
        view.addSubview(backButton)
        NSLayoutConstraint.activate(backButtonConstraints)
        
        NSLayoutConstraint.activate(endTextkConstraints)
        
        setUpMap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func backButtonTap() {
        CardsViewPresenter.goToMain()
    }
    
    func card(fromData data: [Any]) -> SwipeCard {
        let card = SwipeCard()
    
        let content = AppDelegate.container.resolve(InterfaceExt.self)!.basicCard(type: data[0] as! String, title: data[1] as! String, description: data[2] as! String, workHours: data[3] as! String, bill: data[4] as! Int, isRecommended: data[5] as! Bool)
        
        card.swipeDirections = [.left, .right]
        card.content = content
          
        let leftOverlay = UIView()
        leftOverlay.layer.cornerRadius = 23
        leftOverlay.backgroundColor = .red
        
        let rightOverlay = UIView()
        rightOverlay.layer.cornerRadius = 23
        rightOverlay.backgroundColor = UIColor(named: "YellowColor")
                
        card.setOverlays([.left: leftOverlay, .right: rightOverlay])
          
        return card
    }
    
    var locationManager: CLLocationManager!
    
    var setRegionFlag = true
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        if setRegionFlag {
            mapView.setRegion(region, animated: false)
            setRegionFlag = !setRegionFlag
        }
        
    }
    
//    func makeRect(coordinates:[CLLocationCoordinate2D]) -> MKMapRect {
//        var rect = MKMapRect()
//        var coordinates = coordinates
//        if !coordinates.isEmpty {
//            let first = coordinates.removeFirst()
//            var top = first.latitude
//            var bottom = first.latitude
//            var left = first.longitude
//            var right = first.longitude
//            coordinates.forEach { coordinate in
//                top = max(top, coordinate.latitude)
//                bottom = min(bottom, coordinate.latitude)
//                left = min(left, coordinate.longitude)
//                right = max(right, coordinate.longitude)
//            }
//            let topLeft = MKMapPoint(CLLocationCoordinate2D(latitude:top, longitude:left))
//            let bottomRight = MKMapPoint(CLLocationCoordinate2D(latitude:bottom, longitude:right))
//            rect = MKMapRect(x:topLeft.x, y:topLeft.y,
//                             width:bottomRight.x - topLeft.x, height:bottomRight.y - topLeft.y)
//        }
//        return rect
//    }
    
    func setUpMap() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        DispatchQueue.background(background: { [self] in
            if (CLLocationManager.locationServicesEnabled()) {
                
                locationManager.requestAlwaysAuthorization()
                locationManager.startUpdatingLocation()
            }
        })
        mapView.showsUserLocation = true
    }
}
