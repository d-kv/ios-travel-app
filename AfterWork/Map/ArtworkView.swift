//
//  ArtworkView.swift
//  AfterWork
//
//  Created by Евгений Парфененков on 10.03.2023.
//

import Foundation
import UIKit
import MapKit
import Contacts

class Artwork: NSObject, MKAnnotation {
    let title: String?
    let locationName: String?
    let discipline: String?
    let coordinate: CLLocationCoordinate2D
    let image: UIImage?
    
    var mapItem: MKMapItem? {
      guard let location = locationName else {
        return nil
      }

      let addressDict = [CNPostalAddressStreetKey: location]
      let placemark = MKPlacemark(
        coordinate: coordinate,
        addressDictionary: addressDict)
      let mapItem = MKMapItem(placemark: placemark)
      mapItem.name = title
      return mapItem
    }

    
    init ( title: String?,
        locationName: String?,
        discipline: String?,
        coordinate: CLLocationCoordinate2D,
           image: UIImage?) {
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
            
            let btn = UIButton(type: .detailDisclosure)
            canShowCallout = true
            calloutOffset = CGPoint(x: 0, y: 0)
            rightCalloutAccessoryView = btn
            

            image = artwork.image
            
        }
        
    }

}
