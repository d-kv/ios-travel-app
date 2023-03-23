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
  // MARK: Internal

  static func getCards() -> [[Any]]? { return DI.poiData.placesList }

  func goToMain() {
    let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    sceneDelegate.window!.rootViewController?.dismiss(animated: true)

    controller.dismiss(animated: true)
  }

  func setUpLocation(locationManager: CLLocationManager) {
    DispatchQueue.background(background: {
      if CLLocationManager.locationServicesEnabled() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
      }
    })
  }

  // MARK: Private

  private let controller = DI.shared.getCardsViewController()
}
