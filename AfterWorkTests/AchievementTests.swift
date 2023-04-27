//
//  AchievementTests.swift
//  AfterWorkTests
//
//  Created by Ruslan Sorokin on 26.04.2023.
//

import Foundation

import XCTest
@testable import AfterWork

class AchievementSerializationTest: XCTestCase {

    let initialAchievement = Achievement(
        kind: Achievement.Kind.hr,
        reached_at: Date()
    )

    func testDataImmutability() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let encoded = try encoder.encode(initialAchievement)
        let gotAchievement = try decoder.decode(Achievement.self, from: encoded)
        XCTAssertEqual(initialAchievement, gotAchievement)

    }

    func testPerformanceEncoding() throws {
        let encoder = JSONEncoder()

        self.measure {
            _ = try? encoder.encode(initialAchievement)
        }
    }

    func testPerformanceDecoding() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let JSONAchievement = try encoder.encode(initialAchievement)

        self.measure {
            // Put the code you want to measure the time of here.
            _ = try? decoder.decode(Achievement.self, from: JSONAchievement)
        }
    }

}
