//
//  CardsViewPresenter.swift
//  AfterWork
//
//  Created by Евгений Парфененков on 15.03.2023.
//

import Foundation
import MapKit
import UIKit

class CardsViewPresenter {
  let controller = DI.container.resolve(CardsViewController.self)!

  func goToMain() {
    let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    sceneDelegate.window!.rootViewController?.dismiss(animated: true)
  }

  func setUpLocation(locationManager: CLLocationManager) {
    DispatchQueue.background(background: {
      if CLLocationManager.locationServicesEnabled() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
      }
    })
  }
}
