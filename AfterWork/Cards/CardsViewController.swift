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
    
    var cards: [Places] = CardsViewPresenter.getCards() ?? [Places(id: 0, yaid: 0, category: String(localized: "instruction_title"), name: String(localized: "instruction_desc"), url: "", latitude: "", longitude: "", address: "", description: String(localized: "instruction_text"), isRecommended: false, phone: "", availability: "")]
    
    func numberOfCards(in cardStack: Shuffle_iOS.SwipeCardStack) -> Int {
    
        return cards.count - 1
        
    }
    
    // MARK: - Delegations
    
    func didSwipeAllCards(_ cardStack: SwipeCardStack) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.mapView.frame.origin.y = self.view.frame.height + 50
        }, completion: { _ in
            self.mapView.isHidden = true
        })
        
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        
        mapView.removeAnnotations(mapView.annotations)
        
        var currentAnnotationImage = UIImage(named: "marker")
        let currentCard = cards[index]
        let nextCard = cards[index + 1]
        
        if nextCard.isRecommended { currentAnnotationImage =  UIImage(named: "markerTop") }
        
        let artwork = Artwork(
            title: currentCard.name,
            locationName: currentCard.category,
            discipline: currentCard.category,
            coordinate: CLLocationCoordinate2D(latitude: Double(nextCard.latitude) ?? CLLocationDegrees(0), longitude: Double(nextCard.longitude) ?? CLLocationDegrees(0)), //cards[0][6]
            image: currentAnnotationImage
        )
        mapView.addAnnotation(artwork)
        
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
            
            if (currentCard.isRecommended) { currentAnnotationImage =  UIImage(named: "markerTop") }
            let artwork = Artwork(
                title: currentCard.name,
                locationName: currentCard.category,
                discipline: currentCard.category,
                coordinate: CLLocationCoordinate2D(latitude: Double(currentCard.latitude) ?? CLLocationDegrees(0), longitude: Double(currentCard.longitude) ?? CLLocationDegrees(0)), //cards[0][6]
                image: currentAnnotationImage
            )
            
            mapViewController.targetPoint = artwork
        }
        
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cardTap))
        gesture.numberOfTapsRequired = 1
        cardStack.card(forIndexAt: index + 1)?.content?.isUserInteractionEnabled = true
        cardStack.card(forIndexAt: index + 1)?.content?.addGestureRecognizer(gesture)
        
        (cardStack.card(forIndexAt: index + 1)?.content?.subviews[8] as? UIButton)?.addTarget(self, action: #selector(openLink), for: .touchUpInside)
        currentIndex = index
    }
    
    func cardStack(_ cardStack: Shuffle_iOS.SwipeCardStack, cardForIndexAt index: Int) -> Shuffle_iOS.SwipeCard {
        
        return DI.shared.getInterfaceExt().card(fromData: cards[index])
    }
    
    var currentIndex = 0
    @objc private func cardTap() {
        self.dismiss(animated: true)
        
        var currentAnnotationImage = UIImage(named: "marker")
        if (cards[currentIndex + 1].isRecommended) { currentAnnotationImage =  UIImage(named: "markerTop") }
                    
        let mapViewController = DI.shared.getMapViewController_Cards()
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        sceneDelegate.window!.rootViewController?.present(mapViewController, animated: true)
        
        let artwork = Artwork(
            title: cards[currentIndex].name,
            locationName: cards[currentIndex + 1].category,
            discipline: cards[currentIndex].category,
            coordinate: CLLocationCoordinate2D(latitude: Double(cards[currentIndex + 1].latitude) as? CLLocationDegrees ?? CLLocationDegrees(0), longitude: Double(cards[currentIndex + 1].longitude) as? CLLocationDegrees ?? CLLocationDegrees(0)),
            image: currentAnnotationImage
        )
        
        mapViewController.targetPoint = artwork
    }
    @objc private func openLink(_ sender: UIButton) {
        if let url = URL(string: cards[currentIndex + 1].url) {
            UIApplication.shared.open(url)
        }
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
    
//    @objc func tap(_ sender: UIButton) {
//        print("TAPAAAAA")
//    }
    
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
        let text = NSAttributedString(string: "Подборка пока что закончилась,\nзагляните позже", attributes: [NSAttributedString.Key.paragraphStyle:style, NSAttributedString.Key.font:UIFont(name: "Helvetica Neue", size: 28) ?? .systemFont(ofSize: 28), NSAttributedString.Key.foregroundColor:UIColor(named: "LightGrayColor") ?? .black])
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
        
        let location = (locations.last ?? CLLocation(latitude: 0, longitude: 0)) as CLLocation
        
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
