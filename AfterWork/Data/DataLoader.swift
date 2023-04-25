//
//  DataHandler.swift
//  AfterWork
//
//  Created by Евгений Парфененков on 20.03.2023.
//

import Foundation
import UIKit
import CoreLocation

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

    var cache = CacheImpl.shared

    var places = [Places]()
    var placesSearch = [Places]()

    func loadData() -> Bool {

        places.append(
            Places(
                id: 0, yaid: 0, category: String(localized: "instruction_title"),
                name: String(localized: "instruction_desc"), url: "", latitude: "",
                longitude: "", address: "", description: String(localized: "instruction_text"),
                isRecommended: false, phone: "", availability: ""
            )
        )

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
                    let loginViewController = DI.shared.getLoginViewController()
                    loginViewController.modalPresentationStyle = .fullScreen

                    let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
                    sceneDelegate.window!.rootViewController?.present(loginViewController, animated: true)
                }
                return
            }

            switch response.statusCode {
            case 200: // success
                if let jsonArray = try? JSONSerialization.jsonObject(with: String(data: data, encoding: .utf8)?
                    .data(using: .utf8) ?? Data(), options: .allowFragments) as? [Dictionary<String, Any>] {
                    for i in jsonArray {
                        let newData = try? JSONSerialization.data(withJSONObject: i)
                        self.places.append(self.cache.parse(json: newData ?? Data()))
                    }
                    DispatchQueue.main.async {
                        if let topVC = UIApplication.getTopViewController() {
                            topVC.view.removeBluerLoader()
                        }
                    }

                } else {
                    DispatchQueue.main.async {
                        let loginViewController = DI.shared.getLoginViewController()
                        loginViewController.modalPresentationStyle = .fullScreen

                        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
                        sceneDelegate.window!.rootViewController?.present(loginViewController, animated: true)
                    }
                }

            default:
                DispatchQueue.main.async {
                    let loginViewController = DI.shared.getLoginViewController()
                    loginViewController.modalPresentationStyle = .fullScreen

                    let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
                    sceneDelegate.window!.rootViewController?.present(loginViewController, animated: true)
                }
            }
        }

        task.resume()
        return true
    }
}
