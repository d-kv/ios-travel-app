//
//  MainViewPresenter.swift
//  Tinkoff Travel
//
//  Created by Евгений Парфененков on 02.03.2023.
//

import Foundation
import UIKit
import TinkoffID

protocol MainViewPresenterDelegate: AnyObject {
    func mainViewPresenter(_ reposViewModel: MainViewPresenter,
                            isLoading: Bool)
}


final class MainViewPresenter {
    weak var delegate: MainViewPresenterDelegate?
    
    func openSettings() {
        let settingsViewController = DI.shared.getSettingsViewController()
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        sceneDelegate.window!.rootViewController?.present(settingsViewController, animated: true)
    }
    
    func goToMap() {
        MapViewController.isSearching = false
        let mapViewController = DI.shared.getMapViewController_Map()
        mapViewController.modalPresentationStyle = .fullScreen

        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        sceneDelegate.window!.rootViewController?.present(mapViewController, animated: true)
        
    }
    
    func goToCards(type: String) {
        switch type {
        case "cafe":
            cardSearch(categories: ["bars", "cafe", "fast food"])
            
        case "rest":
            cardSearch(categories: ["restaurants", "sushi"])
        case "hotel":
            cardSearch(categories: ["hotels"])
        case "culture":
            cardSearch(categories: ["museum", "spa", "malls", "fallback services", "confectionary", "concert hall"])
        default:
            CardsViewPresenter.isSearching = false
            
        }
        let cardsViewController = DI.shared.getCardsViewController()
        cardsViewController.modalPresentationStyle = .fullScreen
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        sceneDelegate.window!.rootViewController?.present(cardsViewController, animated: true)
    }
    
    func goToLogin() {
        let loginViewController = DI.shared.getLoginViewController()
        loginViewController.modalPresentationStyle = .fullScreen
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        sceneDelegate.window!.rootViewController?.present(loginViewController, animated: true)
    }
    
    func search(req: String) {
        let searchReq = req
        var newData = [[]]
        for (index, element) in (PlacesList.get()).enumerated() {

            let newStr = (element[1] as? String ?? "") +
            (element[2] as? String ?? "") +
            (element[3] as? String ?? "") +
            (element[6] as? String ?? "")// +
//            (element[9] as? String ?? "")
            if newStr.smartContains(searchReq) {
                newData.append(element)
            }
        }
        newData.remove(at: 0)
        PlacesListSearch.set(newData: newData)
        MapViewController.isSearching = true
        DispatchQueue.main.async {
            if let topVC = UIApplication.getTopViewController() {
                topVC.present(DI.shared.getMapViewController_Map(), animated: true)
            }
        }
        
    }
    private func cardSearch(categories: [String]) {
        var newData = [[]]
        for (index, element) in (PlacesList.get()).enumerated() {
            let newStr = (element[1] as? String ?? "") +
            (element[2] as? String ?? "") +
            (element[3] as? String ?? "") +
            (element[6] as? String ?? "") //+
//            (element[9] as? String ?? "")
            for i in categories {
                if newStr.smartContains(i) {
                    newData.append(element)
                }
            }
        }
        newData.remove(at: 0)
        PlacesListSearch.set(newData: newData)
        CardsViewPresenter.isSearching = true
    }
    
    let preferences = UserDefaults.standard
    
    func enteredApp() {
        
        self.delegate?.mainViewPresenter(self, isLoading: true)
        
        
        var idToken = AuthService.getSecret(key: "idToken")
        var refreshToken = AuthService.getSecret(key: "refreshToken")
        
        if idToken == "ID" {
            AuthService.isAuthDebug = true
            print("")
        } else {
            print("")
        }
        
        if !AuthService.tinkoffId.isTinkoffAuthAvailable && !AuthService.isAuthDebug {
            self.delegate?.mainViewPresenter(self, isLoading: false)
            goToLogin()
            
        } else if AuthService.isAuthDebug {
            
            if DataLoader.loadData() {
                print("")
            } else {
                print("")
            }
            
        } else {
            
            if idToken != "" {
                AuthService.tinkoffId.obtainTokenPayload(using: refreshToken, handleRefreshToken)
            } else {
                self.delegate?.mainViewPresenter(self, isLoading: false)
                goToLogin()
            }
            
        }
    }
    
    
    private func handleRefreshToken(_ result: Result<TinkoffTokenPayload, TinkoffAuthError>) {
        do {
            let credentials = try result.get()
            
//            preferences.set(credentials.idToken, forKey: "idToken")
//            preferences.set(credentials.accessToken, forKey: "accessToken")
//            preferences.set(credentials.refreshToken, forKey: "refreshToken")
            AuthService.setSecret(key: "idToken", value: credentials.idToken)
            AuthService.setSecret(key: "accessToken", value: credentials.accessToken)
            AuthService.setSecret(key: "refreshToken", value: credentials.refreshToken ?? "")
            
            var host = ""
            if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
                let keys = NSDictionary(contentsOfFile: path) ?? NSDictionary()
                host = keys["HOST"] as? String ?? ""
            }
            
            let url = URL(string: host + "/api/auth?tid_id=" + credentials.idToken + "&tid_accessToken=" + credentials.accessToken)!
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
                        self.delegate?.mainViewPresenter(self, isLoading: false)
                        self.goToLogin()
                    }
                    return
                }

                switch response.statusCode {
                case 200: // success
                    
                    if let jsonArray = try? JSONSerialization.jsonObject(with: String(data: data, encoding: .utf8)?.data(using: .utf8) ?? Data(), options : .allowFragments) as? [Dictionary<String,Any>] {
                        
                        AuthService.setSecret(key: "idToken", value: jsonArray[0]["TID_ID"] as? String ?? "")
                        AuthService.setSecret(key: "accessToken", value: jsonArray[0]["TID_AccessToken"] as? String ?? "")
                        self.preferences.set(jsonArray[0]["firstName"] as? String ?? "", forKey: "firstName")
                        self.preferences.set(jsonArray[0]["lastName"] as? String ?? "", forKey: "lastName")
                        self.preferences.set(jsonArray[0]["isAdmin"] as? Bool ?? false, forKey: "isAdmin")
                        self.preferences.set(jsonArray[0]["achievements"] as? String ?? "", forKey: "achievements")
                        if !DataLoader.loadData() {
                            self.goToLogin()
                        }

                        
                    } else {
                        DispatchQueue.main.async {
                            self.delegate?.mainViewPresenter(self, isLoading: false)
                            self.goToLogin()
                        }
                    }
                    
                default:
                    DispatchQueue.main.async {
                        self.delegate?.mainViewPresenter(self, isLoading: false)
                        self.goToLogin()
                    }
                }
            }

            task.resume()
            
        } catch {
            self.delegate?.mainViewPresenter(self, isLoading: false)
            goToLogin()
        }
    }
}
