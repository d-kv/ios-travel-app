//
//  Achievement.swift
//  AfterWork
//
//  Created by Ruslan Sorokin on 26.04.2023.
//

import Foundation

private let enum_suffix_len = 4

struct Achievement: Codable, Equatable{

    enum Kind: String, Codable, Equatable{
        case unspecified = "ACH_UNSPECIFIED"
        case good_rest = "ACH_GOOD_REST"
        case inspector_michelin = "ACH_INSPECTOR_MICHELIN"
        case guide = "ACH_GUIDE"
        case true_green = "ACH_TRUE_GREEN"
        case bad_user = "ACH_BAD_USER"
        case hr = "ACH_HR"
        case premium = "ACH_PREMIUM"
        case difficult_choice = "ACH_DIFFICULT_CHOICE"
        case tester = "ACH_TESTER"
        case deus_vult = "ACH_DEUS_VULT"

    }

    private enum CodingKeys: String, CodingKey {
        case kind, reached_at
    }

    var kind: Kind
    var reached_at: Date

    func getName() -> String { String(self.kind.rawValue.dropFirst(enum_suffix_len)) }

}
