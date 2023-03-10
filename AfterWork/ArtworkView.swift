//
//  ArtworkView.swift
//  AfterWork
//
//  Created by Евгений Парфененков on 10.03.2023.
//

import Foundation
import UIKit
import MapKit

class Artwork: NSObject, MKAnnotation {
    let title: String?
    let locationName: String?
    let discipline: String?
    let coordinate: CLLocationCoordinate2D
    let image: UIImage?
    
    
    init(
        title: String?,
        locationName: String?,
        discipline: String?,
        coordinate: CLLocationCoordinate2D,
        image: UIImage?
        
    ) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        self.image = image
        
        
                
        super.init()
    }

        var subtitle: String? {
            return locationName
      }
}

class ArtworkView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let artwork = newValue as? Artwork else {
                return
            }

            canShowCallout = true
            calloutOffset = CGPoint(x: 0, y: 0)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

            image = artwork.image
        }
    }
}

