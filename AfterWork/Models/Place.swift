//
//  Place.swift
//  AfterWork
//
//  Created by Ruslan Sorokin on 26.04.2023.
//

import Foundation

struct Place: Codable {
    struct Location: Codable {
        let latitude: Double
        let longitude: Double
    }

    let uuid: String
    let address: String
    let name: String
    let description: String
    let phone: String
    let url: URL

    let category: Category
    let location: Location

}
