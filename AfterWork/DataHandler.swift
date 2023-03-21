//
//  DataHandler.swift
//  AfterWork
//
//  Created by Евгений Парфененков on 20.03.2023.
//

import Foundation
import UIKit

struct UserData {
    
    var userName: String! = nil
    var userImage: UIImage! = nil
    var achievements: Array<Int>? = nil
    
    init() {
        self.userName = ""
        self.userImage = UIImage()
        self.achievements = []
    }
}

struct PoiData {
    var placesList: Array<Array<Any>>? = nil
    
    init() {
        self.placesList = []
    }
}

class DataLoader {
    
//    lat a = [
//        "123456", // UID ! +
//        "Maksima Gorkogo, dom 2", // addres ! +
//        "Papa Jhones", // name ! +
//        "56.345436", // latitude ! +
//        "48.234674", // longitude ! +
//        "Restaraunt", // category ! +
//        "Recommended", // recommended !
//        "2000rub", // bill ?
//        "This is some shit", // Description ?
//        "+79991234050" // phone ?
//        "12:00 - 22:00" // workhours ?
//    ]
    
    static func loadData() {
        let data1 = [123456, "Restoraunt", "Papa Jhones", "Some address", 56.2965039, 44.9360589, "Somde Description", false, 4, "+79991234060", "12:00 - 22:00"] as [Any]
        let data2 = [123456, "Restoraunt", "Papa Jhones", "Some address", 56.2965039, 44.9360589, "Somde Description", false, 4, "+79991234060", "12:00 - 22:00"] as [Any]
        let data3 = [123456, "Restoraunt", "Papa Jhones", "Some address", 56.2965039, 44.9360589, "Somde Description", false, 4, "+79991234060", "12:00 - 22:00"] as [Any]
        let data4 = [123456, "Restoraunt", "Papa Jhones", "Some address", 56.2965039, 44.9360589, "Somde Description", false, 4, "+79991234060", "12:00 - 22:00"] as [Any]
        let data5 = [123456, "Restoraunt", "Papa Jhones", "Some address", 56.2965039, 44.9360589, "Somde Description", false, 4, "+79991234060", "12:00 - 22:00"] as [Any]
        let data6 = [123456, "Restoraunt", "Papa Jhones", "Some address", 56.2965039, 44.9360589, "Somde Description", false, 4, "+79991234060", "12:00 - 22:00"] as [Any]
        let data7 = [123456, "Restoraunt", "Papa Jhones", "Some address", 55.2965039, 44.9360589, "Somde Description", false, 4, "+79991234060", "12:00 - 22:00"] as [Any]
        
        DI.poiData.placesList?.append(data1)
        DI.poiData.placesList?.append(data2)
        DI.poiData.placesList?.append(data3)
        DI.poiData.placesList?.append(data4)
        DI.poiData.placesList?.append(data5)
        DI.poiData.placesList?.append(data6)
        DI.poiData.placesList?.append(data7)
    }
    
}
