//
//  LocationTests.swift
//  AfterWorkTests
//
//  Created by Ruslan Sorokin on 27.04.2023.
//

import XCTest
@testable import AfterWork

class LocationSerializationTest: XCTestCase {

    let initialLocation = Place.Location.init(
        latitude: 56.3254742,
        longitude: 44.0015685
    )

    func testDataImmutability() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let encoded = try encoder.encode(initialLocation)
        let gotLocation = try decoder.decode(Place.Location.self, from: encoded)
        XCTAssertEqual(initialLocation, gotLocation)

    }

    func testPerformanceEncoding() throws {
        let encoder = JSONEncoder()

        self.measure {
            _ = try? encoder.encode(initialLocation)
        }
    }

    func testPerformanceDecoding() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let JSONLocation = try encoder.encode(initialLocation)

        self.measure {
            // Put the code you want to measure the time of here.
            _ = try? decoder.decode(Place.Location.self, from: JSONLocation)
        }
    }

}

class LocationCtorTest: XCTestCase {

    struct TestCase{
        var latitude: Double
        var longitude: Double
    }

    func testRightCoordinates() throws {
        let test_cases = [
            TestCase(latitude: 55, longitude: 55),
            TestCase(latitude: 90, longitude: 180),
            TestCase(latitude: -90, longitude: -180),
            TestCase(latitude: 90, longitude: -180),
            TestCase(latitude: -90, longitude: 180)
        ]

        for test_case in test_cases{
            XCTAssertNotNil(Place.Location.init(
                latitude:test_case.latitude, longitude: test_case.longitude),
                            "must successfully validate the data")
        }
    }

    func testWrongCoordinates() throws {
        let test_cases = [
            TestCase(latitude: -500, longitude: 500),
            TestCase(latitude: 91, longitude: 181),
            TestCase(latitude: -91, longitude: -181),
            TestCase(latitude: 91, longitude: -180),
            TestCase(latitude: -90, longitude: 181),
            TestCase(latitude: 90, longitude: -181),
            TestCase(latitude: -91, longitude: 180)
        ]

        for test_case in test_cases{
            XCTAssertNil(Place.Location.init(
                latitude:test_case.latitude, longitude: test_case.longitude),
                         "must fail the validation of the data")
        }
    }

}
