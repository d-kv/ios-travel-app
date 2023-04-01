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
    
    func goToCards() {
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
    
    let preferences = UserDefaults.standard
    
    func enteredApp() {
        
        self.delegate?.mainViewPresenter(self, isLoading: true)
        
        if preferences.string(forKey: "idToken") == "ID" {
            AuthService.isAuthDebug = true
            print("okay debug")
        } else {
            print("okay not")
        }
        
        if !AuthService.tinkoffId.isTinkoffAuthAvailable && !AuthService.isAuthDebug {
            self.delegate?.mainViewPresenter(self, isLoading: false)
            //DataLoader.loadData()
            goToLogin()
        } else if AuthService.isAuthDebug {
            
            self.delegate?.mainViewPresenter(self, isLoading: false)
            if DataLoader.loadData() {
                print("okay")
            } else {
                print("okay")
            }
        } else {
            
            if preferences.string(forKey: "idToken") ?? nil != nil {
                let refreshToken = preferences.string(forKey: "refreshToken") ?? ""
                AuthService.tinkoffId.obtainTokenPayload(using: refreshToken, handleRefreshToken)
                
            } else {
                self.delegate?.mainViewPresenter(self, isLoading: false)
                goToLogin()
            }
        }
        print("okay", AuthService.isAuthDebug)
    }
    
    
    private func handleRefreshToken(_ result: Result<TinkoffTokenPayload, TinkoffAuthError>) {
        do {
            let credentials = try result.get()
            
            preferences.set(credentials.idToken, forKey: "idToken")
            preferences.set(credentials.accessToken, forKey: "accessToken")
            preferences.set(credentials.refreshToken, forKey: "refreshToken")
            
            let url = URL(string: "http://82.146.33.253:8000/api/auth?tid_id=" + preferences.string(forKey: "idToken")! + "&tid_accessToken=" + preferences.string(forKey: "accessToken")!)!
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
                    
                    if let jsonArray = try? JSONSerialization.jsonObject(with: String(data: data, encoding: .utf8)!.data(using: .utf8)!, options : .allowFragments) as? [Dictionary<String,Any>] {
                        //print(jsonArray)
                        print(jsonArray[0])
                        self.preferences.set(jsonArray[0]["TID_ID"] as! String, forKey: "idToken")
                        self.preferences.set(jsonArray[0]["TID_AccessToken"] as! String, forKey: "accessToken")
                        self.preferences.set(jsonArray[0]["firstName"] as! String, forKey: "firstName")
                        self.preferences.set(jsonArray[0]["lastName"] as! String, forKey: "lastName")
                        self.preferences.set(jsonArray[0]["isAdmin"] as! Bool, forKey: "isAdmin")
                        self.preferences.set(jsonArray[0]["achievements"] as! String, forKey: "achievements")
                        if !DataLoader.loadData() {
                            self.goToLogin()
                        } else {
                            DispatchQueue.main.async { self.delegate?.mainViewPresenter(self, isLoading: false) }
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
