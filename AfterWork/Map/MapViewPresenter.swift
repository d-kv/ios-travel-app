//
//  MapViewPresenter.swift
//  Tinkoff Travel
//
//  Created by Евгений Парфененков on 02.03.2023.
//

import Foundation
import MapKit
import UIKit

// MARK: - MapViewPresenterDelegate

protocol MapViewPresenterDelegate: AnyObject {
  func switchedPoint(target: Artwork, isSwitched: Bool)
}

// MARK: - MapViewPresenter

final class MapViewPresenter {
  weak var delegate: MapViewPresenterDelegate?

  static func goToMain() {
    let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    sceneDelegate.window!.rootViewController?.dismiss(animated: true)
    // sceneDelegate.window!.rootViewController?.present(mainViewController, animated: true)
  }

  func calculateDistance(mapView: MKMapView) {
    delegate?.switchedPoint(target: mapView.annotations[0] as! Artwork, isSwitched: true)
    NSLog("Target1", 1)
  }
}
