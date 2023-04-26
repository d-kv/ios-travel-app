//
//  AfterWorkTests.swift
//  AfterWorkTests
//
//  Created by Ruslan Sorokin on 26.04.2023.
//

import XCTest
@testable import AfterWork

class CategoryTest: XCTestCase {

    let initialCategory = Category.init(
        main: [
            Category.Main.unspecified,
            Category.Main.culture,
            Category.Main.entertainment,
            Category.Main.food,
            Category.Main.hospitality
        ],
        sub: [
            Category.Sub.unspecified,
            Category.Sub.russian_cuisine,
            Category.Sub.italian_cuisine,
            Category.Sub.apartments,
            Category.Sub.bowling,
            Category.Sub.camping,
            Category.Sub.gallery,
            Category.Sub.amusement_park,
            Category.Sub.architectural_monuments,
            Category.Sub.beer_house,
            Category.Sub.pab,
            Category.Sub.vegan_menu,
            Category.Sub.open_mic,
            Category.Sub.nightclub,
            Category.Sub.coffee_house,
            Category.Sub.library,
            Category.Sub.resort,
            Category.Sub.motel,
            Category.Sub.confectionery,
            Category.Sub.japanese_cuisine,
            Category.Sub.trampoline_park,
            Category.Sub.theatre,
            Category.Sub.water_park,
            Category.Sub.quest_room,
            Category.Sub.festival,
            Category.Sub.kafe,
            Category.Sub.museum,
            Category.Sub.georgian_cuisine,
            Category.Sub.hotel,
            Category.Sub.billiard_club,
            Category.Sub.cinema,
            Category.Sub.american_cuisine,
            Category.Sub.bar,
            Category.Sub.steak,
            Category.Sub.hostel
        ]
    )

    func testSerialization() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let encoded = try encoder.encode(initialCategory)
        let gotCategory = try decoder.decode(Category.self, from: encoded)
        XCTAssertEqual(initialCategory, gotCategory)

    }

    func testPerformanceEncoding() throws {
        let encoder = JSONEncoder()

        self.measure {
            _ = try? encoder.encode(initialCategory)
        }
    }

    func testPerformanceDecoding() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let JSONCategory = try encoder.encode(initialCategory)

        self.measure {
            // Put the code you want to measure the time of here.
            _ = try? decoder.decode(Category.self, from: JSONCategory)
        }
    }

}
