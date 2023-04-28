//
//  User.swift
//  AfterWork
//
//  Created by Ruslan Sorokin on 26.04.2023.
//

import Foundation

struct User: Codable{
    var uuid: UUID{
        UUID.init()
    }

    var first_name: String
    var middle_name: String
    var last_name: String

    var achievements: Array<Achievement>

    // TODO: use enums
    var is_blocked: Bool
    var is_admin: Bool
    var is_premium: Bool

    init(first_name: String, middle_name: String,
         last_name: String, achievements: [Achievement],
         is_blocked: Bool, is_admin: Bool, is_premium: Bool){
        self.first_name = first_name
        self.middle_name = middle_name
        self.last_name = last_name

        self.achievements = achievements

        self.is_blocked = is_blocked
        self.is_admin = is_admin
        self.is_premium = is_premium
    }
}
