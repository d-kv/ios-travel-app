//
//  MapDescViewPresenter.swift
//  AfterWork
//
//  Created by Евгений Парфененков on 23.03.2023.
//

import Foundation
import UIKit
import MapKit


class MapDescViewPresenter {
    
    //weak var delegate: MapDescViewDelegate?
    
    func callNumber(phoneNumber: String) {
        guard let url = URL(string: "tel://\(phoneNumber)"),
            UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}
