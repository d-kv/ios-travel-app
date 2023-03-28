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

    
    static func loadData() -> Bool {
        let preferences = UserDefaults.standard
        
        let data0 = [1, "Инструкция", "Что это такое?", "Some address", 57.2965039, 47.9360589, "Смахнешь влево - получишь карточки, смахнешь вправо - отдохни на браво. А карточки с подсветкой - наши избранные, имей ввиду", false, 4, "+79991234060", "12:00 - 22:00"] as [Any]
//        let data1 = [2, "Restoraunt", "Papa Jhones", "Some address", 55.2965039, 43.9360589, "Somde Description", false, 4, "+79991234060", "12:00 - 22:00"] as [Any]
//        let data2 = [3, "Ресторанyy", "Papa Jhones", "Большая печерская", 56.2965039, 43.9360589, "Somde Description", true, 4, "+79991234060", "12:00 - 22:00"] as [Any]
//        let data3 = [4, "Restoraunt", "Papa Jhones", "Some address", 56.2965039, 46.9360589, "Somde Description", false, 4, "+79991234060", "12:00 - 22:00"] as [Any]
//        let data4 = [5, "Restoraunt", "Papa Jhones", "Some address", 56.2965039, 45.9360589, "Somde Description", false, 4, "+79991234060", "12:00 - 22:00"] as [Any]
//        let data5 = [6, "Restoraunt", "Papa Jhones", "Some address", 55.2965039, 45.9360589, "Somde Description", true, 4, "+79991234060", "12:00 - 22:00"] as [Any]
//        let data6 = [7, "Restoraunt", "Papa Jhones", "Some address", 54.2965039, 45.9360589, "Somde Description", false, 4, "+79991234060", "12:00 - 22:00"] as [Any]
//        let data7 = [8, "Restoraunt", "Papa Jhones", "Some address", 54.2965039, 44.9360589, "Somde Description", false, 4, "+79991234060", "12:00 - 22:00"] as [Any]
        DI.poiData.placesList?.append(data0)
//        DI.poiData.placesList?.append(data1)
//        DI.poiData.placesList?.append(data2)
//        DI.poiData.placesList?.append(data3)
//        DI.poiData.placesList?.append(data4)
//        DI.poiData.placesList?.append(data5)
//        DI.poiData.placesList?.append(data6)
//        DI.poiData.placesList?.append(data7)
                
        
        let url = URL(string: "http://82.146.33.253:8000/api/getlocation?tid_id=" + preferences.string(forKey: "idToken")! + "&tid_accessToken=" + preferences.string(forKey: "accessToken")!)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
            else {                                                               // check for fundamental networking error
                DispatchQueue.main.async {
                    exit(1) //error
                }
                return
            }

            switch response.statusCode {
            case 200: // success
                
                if let jsonArray = try? JSONSerialization.jsonObject(with: String(data: data, encoding: .utf8)!.data(using: .utf8)!, options : .allowFragments) as? [Dictionary<String,Any>] {
                    //print(jsonArray)
                    //self.preferences.set(jsonArray[0]["TID_ID"] as! String, forKey: "idToken")
                    
                    for i in jsonArray {
                        let data7 = [i["id"] as! Int, i["category"] as! String, i["name"] as! String, i["address"] as! String, Double(i["latitude"] as! String), Double(i["longitude"] as! String), i["description"] as! String, i["isRecommended"] as! Bool, 4, i["phone"] as! String, i["availability"] as! String] as [Any]
                        DI.poiData.placesList?.append(data7)
                        print("zhopa", i["id"])
                    }

                } else {
//                    DispatchQueue.main.async {
//                        self.delegate?.mainViewPresenter(self, isLoading: false)
//                        self.goToLogin()
//                    }
                    print("error1")
                    exit(1)
                }
                
            default:
                print("error, \(response.statusCode), \(url)")
                exit(1)
//                DispatchQueue.main.async {
//                    exit(1) // error
//                }
            }
        }

        task.resume()
        return true
    }
}
