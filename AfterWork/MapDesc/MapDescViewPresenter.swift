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
    
    
    func callNumber(phoneNumber: String) {
        let str = phoneNumber.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "")
        guard let url = URL(string: "tel://\(str)"),
            UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    func openLink(website: String) {
        guard let url = URL(string: website),
            UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
