//
//  PlaceTests.swift
//  AfterWorkTests
//
//  Created by Ruslan Sorokin on 27.04.2023.
//

import XCTest
@testable import AfterWork

class PlaceSerializationTest: XCTestCase {

    let initialPlace = Place.init(
        address: "улица Большая Покровская, 2, Нижний Новгород",
        name: "Совок",
        description: "Культовая хенд-мейд лапшичная и выставочное пространство в Нижнем Новгороде!",
        phone: "+7 (953) 574-38-46",
        url: "https://vk.com/sowokfood",
        main_category: [
            Category.Main.food
        ],
        sub_category: [
            Category.Sub.coffee_house,
            Category.Sub.kafe
        ],
        latitude: 56.3254742,
        longitude: 44.0015685
    )

    func testDataImmutability() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let encoded = try encoder.encode(initialPlace)
        let gotPlace = try decoder.decode(Place.self, from: encoded)
        XCTAssertEqual(initialPlace, gotPlace)

    }

    func testPerformanceEncoding() throws {
        let encoder = JSONEncoder()

        self.measure {
            _ = try? encoder.encode(initialPlace)
        }
    }

    func testPerformanceDecoding() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let JSONPlace = try encoder.encode(initialPlace)

        self.measure {
            // Put the code you want to measure the time of here.
            _ = try? decoder.decode(Place.self, from: JSONPlace)
        }
    }

}
