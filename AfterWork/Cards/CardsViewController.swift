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
    
    var cards: Array<Array<Any>> = CardsViewPresenter.getCards()!
    
    func numberOfCards(in cardStack: Shuffle_iOS.SwipeCardStack) -> Int {
    
        return cards.count - 1
        
    }
    
    // MARK: - Delegations
    
    func didSwipeAllCards(_ cardStack: SwipeCardStack) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.mapView.frame.origin.y = self.view.frame.height + 50
        }, completion: {_ in
            self.mapView.isHidden = true
        })
        
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        
        mapView.removeAnnotations(mapView.annotations)
        var currentAnnotationImage = UIImage(named: "marker")
        if (cards[index + 1][7] as! Bool) { currentAnnotationImage =  UIImage(named: "markerTop") }
        
        let artwork = Artwork(
            title: cards[index][2] as? String,
            locationName: "Waikiki Gateway Park",
            discipline: cards[index][1] as? String,
            coordinate: CLLocationCoordinate2D(latitude: cards[index + 1][4] as! CLLocationDegrees, longitude: cards[index + 1][5] as! CLLocationDegrees), //cards[0][6]
            image: currentAnnotationImage
        )
        mapView.addAnnotation(artwork)
        print()
        
        let a = artwork.coordinate
        let b = mapView.userLocation.coordinate
        let apoint = MKMapPoint(a)
        let bpoint = MKMapPoint(b)
        
        mapView.setVisibleMapRect(MKMapRect(x: min(apoint.x, bpoint.x), y: min(apoint.y, bpoint.y), width: abs(apoint.x - bpoint.x), height: abs(apoint.y - bpoint.y)), edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), animated: true)
        
        if direction == .right  && index != 0 {
            
            self.dismiss(animated: true)
                        
            let mapViewController = DI.shared.getMapViewController_Cards()
            let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
            sceneDelegate.window!.rootViewController?.present(mapViewController, animated: true)
            
            if (cards[index][7] as! Bool) { currentAnnotationImage =  UIImage(named: "markerTop") }
            let artwork = Artwork(
                title: cards[index][2] as? String,
                locationName: "Waikiki Gateway Park",
                discipline: cards[index][1] as? String,
                coordinate: CLLocationCoordinate2D(latitude: cards[index][4] as! CLLocationDegrees, longitude: cards[index][5] as! CLLocationDegrees), //cards[0][6]
                image: currentAnnotationImage
            )
            
            mapViewController.targetPoint = artwork
        }
    }
    
    func cardStack(_ cardStack: Shuffle_iOS.SwipeCardStack, cardForIndexAt index: Int) -> Shuffle_iOS.SwipeCard {
        
        return DI.shared.getInterfaceExt().card(fromData: cards[index])
    }
    
    
    
    // MARK: - Main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardStack.dataSource = self
        cardStack.delegate = self
        view.backgroundColor = .black
        
        create()
        setUpContstraints()
        
        setUpLocationManager()
        DI.shared.getCardsViewPresenter().setUpLocation(locationManager: locationManager)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
    }
    
    // MARK: - View
    
    func create() {
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
    }
    
    func setUpContstraints() {
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
        view.addSubview(backButton)
        
        let constraintsArray = [cardStackConstraints, mapViewConstraints, backButtonConstraints, endTextkConstraints].flatMap{$0}
        NSLayoutConstraint.activate(constraintsArray)
    }
    
    @objc func backButtonTap() {
        DI.shared.getCardsViewPresenter().goToMain()
    }
    
    // MARK: - Map and location
    
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
    
    func setUpLocationManager() {
        mapView.showsUserLocation = true
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
}
