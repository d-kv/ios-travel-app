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
    
    var userName: String?
    var userImage: UIImage?
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
        //let preferences = UserDefaults.standard
        
        let data0 = [1, String(localized: "instruction_title"), String(localized: "instruction_desc"), "Some address", 57.2965039, 47.9360589, String(localized: "instruction_text"), false, 4, "+79991234060", "12:00 - 22:00"] as [Any]

        DI.poiData.placesList?.append(data0)
        
        let location = DI.shared.getMainViewController().getLocation()
        let lat = String(location.latitude)
        let lng = String(location.longitude)
        
        var host = ""
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
            let keys = NSDictionary(contentsOfFile: path) ?? NSDictionary()
            host = keys["HOST"] as? String ?? ""
        }
        
        let url = URL(string: host + "/api/getlocation?tid_id=" + IAuthService.shared.getSecret(key: "idToken") + "&tid_accessToken=" + IAuthService.shared.getSecret(key: "accessToken") + "&lat=" + lat + "&lng=" + lng)!
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
                    if let topVC = UIApplication.getTopViewController() {
                        topVC.present(DI.shared.getLoginViewController(), animated: true)
                    }
                }
                return
            }

            switch response.statusCode {
            case 200: // success
                
                if let jsonArray = try? JSONSerialization.jsonObject(with: String(data: data, encoding: .utf8)?.data(using: .utf8) ?? Data(), options : .allowFragments) as? [Dictionary<String,Any>] {
                    for i in jsonArray {
                        let data7 = [i["id"] as? Int ?? 0, i["category"] as? String ?? "", i["name"] as? String ?? "", i["url"] as? String ?? "", Double(i["latitude"] as? String ?? "") ?? 0, Double(i["longitude"] as? String ?? "") ?? 0, i["description"] as? String ?? "", i["isRecommended"] as? Bool ?? false, 4, i["phone"] as? String ?? "", i["availability"] as? String ?? ""] as [Any]
                        DI.poiData.placesList?.append(data7)
                    }
                    DispatchQueue.main.async {
                        if let topVC = UIApplication.getTopViewController() {
                            topVC.view.removeBluerLoader()
                        }
                    }

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
