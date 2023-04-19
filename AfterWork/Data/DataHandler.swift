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

struct Places: Codable {
    var id: Int
    var yaid: Int
    
    var category: String
    var name: String
    var url: String
    
    var latitude: String
    var longitude: String
    
    var address: String
    var description: String
    var isRecommended: Bool
    var phone: String
    var availability: String
}

protocol DataLoader {
    func loadData() -> Bool
}

class DataLoaderImpl: DataLoader {
    
    static let shared = DataLoaderImpl()
    
    var places = [Places]()
    var placesSearch = [Places]()
    
    private func parse(json: Data) -> Places {
        let decoder = JSONDecoder()
        var place = Places(id: 0, yaid: 0, category: "", name: "", url: "", latitude: "", longitude: "", address: "", description: "", isRecommended: false, phone: "", availability: "")
        do {
            place = try decoder.decode(Places.self, from: json)
            places.append(place)
        } catch {
            print("debugerror: \(error)")
        }
        
        return place
    }
    
    func loadData() -> Bool {
        //let data0 = [1, String(localized: "instruction_title"), String(localized: "instruction_desc"), "Some address", 57.2965039, 47.9360589, String(localized: "instruction_text"), false, 4, "+79991234060", "12:00 - 22:00"] as [Any]
        
        places.append(Places(id: 0, yaid: 0, category: String(localized: "instruction_title"), name: String(localized: "instruction_desc"), url: "", latitude: "", longitude: "", address: "", description: String(localized: "instruction_text"), isRecommended: false, phone: "", availability: ""))
        //DI.poiData.placesList?.append(data0)
        
        let location = DI.shared.getMainViewController().getLocation()
        let lat = String(location.latitude)
        let lng = String(location.longitude)
        
        var host = ""
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
            let keys = NSDictionary(contentsOfFile: path) ?? NSDictionary()
            host = keys["HOST"] as? String ?? ""
        }
        
        var idToken = CacheImpl.shared.getSecret(key: "idToken")
        var accessToken = CacheImpl.shared.getSecret(key: "accessToken")
        
        let url = URL(string: host + "/api/getlocation?tid_id=" + idToken + "&tid_accessToken=" + accessToken + "&lat=" + lat + "&lng=" + lng)!
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
                
//                if let her = try? JSONSerialization.jsonObject(with: String(data: data, encoding: .utf8)?.data(using: .utf8) ?? Data(), options : .allowFragments) as? [Dictionary<String,Any>] {
//                    for i in her {
//                        let newData = try? JSONSerialization.data(withJSONObject: i)
//                        self.places.append(self.parse(json: newData ?? Data()))
//                    }
//                }
                
//                if let jsonArray = try? JSONSerialization.jsonObject(with: String(data: data, encoding: .utf8)?.data(using: .utf8) ?? Data(), options : .allowFragments) as? [Dictionary<String,Any>] {
//                    for i in jsonArray {
//                        let data7 = [i["id"] as? Int ?? 0, i["category"] as? String ?? "", i["name"] as? String ?? "", i["url"] as? String ?? "", Double(i["latitude"] as? String ?? "") ?? 0, Double(i["longitude"] as? String ?? "") ?? 0, i["description"] as? String ?? "", i["isRecommended"] as? Bool ?? false, 4, i["phone"] as? String ?? "", i["availability"] as? String ?? ""] as [Any]
//                        DI.poiData.placesList?.append(data7)
//                    }
//                    print("debug: \(self.places)")
//                    DispatchQueue.main.async {
//                        if let topVC = UIApplication.getTopViewController() {
//                            topVC.view.removeBluerLoader()
//                        }
//                    }
                    
                if let jsonArray = try? JSONSerialization.jsonObject(with: String(data: data, encoding: .utf8)?.data(using: .utf8) ?? Data(), options : .allowFragments) as? [Dictionary<String,Any>] {
                    for i in jsonArray {
                        let newData = try? JSONSerialization.data(withJSONObject: i)
                        self.places.append(self.parse(json: newData ?? Data()))
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
