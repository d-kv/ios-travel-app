//
//  DataHandler.swift
//  AfterWork
//
//  Created by Евгений Парфененков on 20.03.2023.
//

import Foundation
import UIKit
import CoreLocation

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
    var placesListSearch: Array<Array<Any>>? = nil
    
    init() {
        self.placesList = []
        self.placesListSearch = []
    }
}

class DataLoader {
    
    
    static func loadData() -> Bool {
        let preferences = UserDefaults.standard
        
        let data0 = [1, "Инструкция", "Что это такое?", "Some address", 57.2965039, 47.9360589, "Смахнешь влево - получишь карточки, смахнешь вправо - отдохни на браво. А карточки с подсветкой - наши избранные, имей ввиду", false, 4, "+79991234060", "12:00 - 22:00"] as [Any]

        DI.poiData.placesList?.append(data0)
        
        let location = DI.shared.getMainViewController().getLocation()
        let lat = String(location.latitude)
        let lng = String(location.longitude)
        
        let url = URL(string: "http://82.146.33.253:8000/api/getlocation?tid_id=" + AuthService.getSecret(key: "idToken") + "&tid_accessToken=" + AuthService.getSecret(key: "accessToken") + "&lat=" + lat + "&lng=" + lng)!
        print(url)
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        print("Loading")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
            else {                                                               // check for fundamental networking error
                DispatchQueue.main.async {
                    if let topVC = UIApplication.getTopViewController() {
                        topVC.present(DI.shared.getLoginViewController(), animated: true)
                    }
                }
                return
            }

            switch response.statusCode {
            case 200: // success
                
                if let jsonArray = try? JSONSerialization.jsonObject(with: String(data: data, encoding: .utf8)!.data(using: .utf8)!, options : .allowFragments) as? [Dictionary<String,Any>] {
                    for i in jsonArray {
                        let data7 = [i["id"] as! Int, i["category"] as! String, i["name"] as! String, i["url"] as! String, Double(i["latitude"] as! String)!, Double(i["longitude"] as! String)!, i["description"] as! String, i["isRecommended"] as! Bool, 4, i["phone"] as! String, i["availability"] as! String] as [Any]
                        DI.poiData.placesList?.append(data7)
                    }
                    DispatchQueue.main.async {
                        if let topVC = UIApplication.getTopViewController() {
                            topVC.view.removeBluerLoader()
                        }
                    }
                    
                    print("Loaded")

                } else {
                    DispatchQueue.main.async {
                        if let topVC = UIApplication.getTopViewController() {
                            topVC.present(DI.shared.getLoginViewController(), animated: true)
                        }
                    }
                }
                
            default:
                DispatchQueue.main.async {
                    if let topVC = UIApplication.getTopViewController() {
                        topVC.present(DI.shared.getLoginViewController(), animated: true)
                    }
                }
            }
        }

        task.resume()
        return true
    }
}
