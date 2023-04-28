//
//  Place.swift
//  AfterWork
//
//  Created by Ruslan Sorokin on 26.04.2023.
//

import Foundation

private let min_latitude = -90.0
private let max_latitude = 90.0
private let min_longitude = -180.0
private let max_longitude = 180.0

private func isValidLatitude(latitude: Double) -> Bool {
    min_latitude <= latitude && latitude <= max_latitude
}

private func isValidLongitude(longitude: Double) -> Bool {
    min_longitude <= longitude && longitude <= max_longitude
}

struct Place: Codable, Equatable {
    struct Location: Codable, Equatable {
        var latitude: Double
        var longitude: Double

        init?(latitude: Double, longitude: Double){
            if !isValidLatitude(latitude: latitude) ||
                !isValidLongitude(longitude: longitude) {
                return nil
            }

            self.latitude = latitude
            self.longitude = longitude
        }
    }

    private var uuid: UUID {
        UUID()
    }

    var address: String
    var name: String
    var description: String
    var phone: String
    var url: String

    var category: Category
    var location: Location

    init?(address: String, name: String,
          description: String, phone: String, url: String,
          main_category: [Category.Main], sub_category: [Category.Sub],
          latitude: Double, longitude: Double){

        if let location_ = Location.init(
            latitude: latitude,
            longitude: longitude)
        {
            self.location = location_
        } else {
            return nil
        }

        self.category = Category(
            main: main_category,
            sub: sub_category
        )

        self.address = address
        self.name = name
        self.description = description
        self.phone = phone
        self.url = url
    }
}
