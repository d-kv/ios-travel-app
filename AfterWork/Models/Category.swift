//
//  Category.swift
//  AfterWork
//
//  Created by Ruslan Sorokin on 26.04.2023.
//

import Foundation

struct Category: Codable, Equatable {
    enum Main: Int, Codable, Equatable{
        case unspecified
        case culture
        case entertainment
        case food
        case hospitality

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            switch try container.decode(String.self) {
            case "MC_UNSPECIFIED": self = .unspecified
            case "MC_CULTURE": self = .culture
            case "MC_ENTERTAINMENT": self = .entertainment
            case "MC_FOOD": self = .food
            case "MC_HOSPITALITY": self = .hospitality
            default: fatalError()
            }
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .unspecified:  try container.encode("MC_UNSPECIFIED")
            case .culture:  try container.encode("MC_CULTURE")
            case .entertainment:  try container.encode("MC_ENTERTAINMENT")
            case .food:  try container.encode("MC_FOOD")
            case .hospitality:  try container.encode("MC_HOSPITALITY")
            }
        }
    }


    enum Sub: Int, Codable, Equatable{
        case unspecified
        case russian_cuisine
        case italian_cuisine
        case apartments
        case bowling
        case camping
        case gallery
        case amusement_park
        case architectural_monuments
        case beer_house
        case pab
        case vegan_menu
        case open_mic
        case nightclub
        case coffee_house
        case library
        case resort
        case motel
        case confectionery
        case japanese_cuisine
        case trampoline_park
        case theatre
        case water_park
        case quest_room
        case festival
        case kafe
        case museum
        case georgian_cuisine
        case hotel
        case billiard_club
        case cinema
        case american_cuisine
        case bar
        case steak
        case hostel

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            switch try container.decode(String.self) {
            case "SC_UNSPECIFIED": self = .unspecified
            case "SC_RUSSIAN_CUISINE": self = .russian_cuisine
            case "SC_ITALIAN_CUISINE": self = .italian_cuisine
            case "SC_APARTMENTS": self = .apartments
            case "SC_BOWLING": self = .bowling
            case "SC_CAMPING": self = .camping
            case "SC_GALLERY": self = .gallery
            case "SC_AMUSEMENT_PARK": self = .amusement_park
            case "SC_ARCHITECTURAL_MONUMENTS": self = .architectural_monuments
            case "SC_BEER_HOUSE": self = .beer_house
            case "SC_PAB": self = .pab
            case "SC_VEGAN_MENU": self = .vegan_menu
            case "SC_OPEN_MIC": self = .open_mic
            case "SC_NIGHTCLUB": self = .nightclub
            case "SC_COFFEE_HOUSE": self = .coffee_house
            case "SC_LIBRARY": self = .library
            case "SC_RESORT": self = .resort
            case "SC_MOTEL": self = .motel
            case "SC_CONFECTIONERY": self = .confectionery
            case "SC_JAPANESE_CUISINE": self = .japanese_cuisine
            case "SC_TRAMPOLINE_PARK": self = .trampoline_park
            case "SC_THEATRE": self = .theatre
            case "SC_WATER_PARK": self = .water_park
            case "SC_QUEST_ROOM": self = .quest_room
            case "SC_FESTIVAL": self = .festival
            case "SC_KAFE": self = .kafe
            case "SC_MUSEUM": self = .museum
            case "SC_GEORGIAN_CUISINE": self = .georgian_cuisine
            case "SC_HOTEL": self = .hotel
            case "SC_BILLIARD_CLUB": self = .billiard_club
            case "SC_CINEMA": self = .cinema
            case "SC_AMERICAN_CUISINE": self = .american_cuisine
            case "SC_BAR": self = .bar
            case "SC_STEAK": self = .steak
            case "SC_HOSTEL": self = .hostel
            default: fatalError()
            }
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .unspecified: try container.encode("SC_UNSPECIFIED")
            case .russian_cuisine: try container.encode("SC_RUSSIAN_CUISINE")
            case .italian_cuisine: try container.encode("SC_ITALIAN_CUISINE")
            case .apartments: try container.encode("SC_APARTMENTS")
            case .bowling: try container.encode("SC_BOWLING")
            case .camping: try container.encode("SC_CAMPING")
            case .gallery: try container.encode("SC_GALLERY")
            case .amusement_park: try container.encode("SC_AMUSEMENT_PARK")
            case .architectural_monuments: try container.encode("SC_ARCHITECTURAL_MONUMENTS")
            case .beer_house: try container.encode("SC_BEER_HOUSE")
            case .pab: try container.encode("SC_PAB")
            case .vegan_menu: try container.encode("SC_VEGAN_MENU")
            case .open_mic: try container.encode("SC_OPEN_MIC")
            case .nightclub: try container.encode("SC_NIGHTCLUB")
            case .coffee_house: try container.encode("SC_COFFEE_HOUSE")
            case .library: try container.encode("SC_LIBRARY")
            case .resort: try container.encode("SC_RESORT")
            case .motel: try container.encode("SC_MOTEL")
            case .confectionery: try container.encode("SC_CONFECTIONERY")
            case .japanese_cuisine: try container.encode("SC_JAPANESE_CUISINE")
            case .trampoline_park: try container.encode("SC_TRAMPOLINE_PARK")
            case .theatre: try container.encode("SC_THEATRE")
            case .water_park: try container.encode("SC_WATER_PARK")
            case .quest_room: try container.encode("SC_QUEST_ROOM")
            case .festival: try container.encode("SC_FESTIVAL")
            case .kafe: try container.encode("SC_KAFE")
            case .museum: try container.encode("SC_MUSEUM")
            case .georgian_cuisine: try container.encode("SC_GEORGIAN_CUISINE")
            case .hotel: try container.encode("SC_HOTEL")
            case .billiard_club: try container.encode("SC_BILLIARD_CLUB")
            case .cinema: try container.encode("SC_CINEMA")
            case .american_cuisine: try container.encode("SC_AMERICAN_CUISINE")
            case .bar: try container.encode("SC_BAR")
            case .steak: try container.encode("SC_STEAK")
            case .hostel: try container.encode("SC_HOSTEL")
            }
        }
    }

    let main: Array<Main>
    let sub: Array<Sub>
}
