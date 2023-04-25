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

enum typeSwitch {
    case cafe
    case rest
    case hotel
    case culture
    case all
}

protocol MainViewPresenterProtocol {
    func openSettings()
    func goToMap()
    func goToCards(type: typeSwitch)
    func goToLogin()
    func search(req: String)
    func enteredApp()
}

final class MainViewPresenter: MainViewPresenterProtocol {
    weak var delegate: MainViewPresenterDelegate?

    let authService = DI.shared.getAuthSerivce()

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

    func goToCards(type: typeSwitch) {
        switch type {
        case .cafe:
            cardSearch(categories: ["bars", "cafe", "fast food"])

        case .rest:
            cardSearch(categories: ["restaurants", "sushi"])
        case .hotel:
            cardSearch(categories: ["hotels"])
        case .culture:
            cardSearch(categories: ["museum", "spa", "malls", "fallback services", "confectionary", "concert hall"])
        case .all:
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
        var newData = [Places]()
        for (index, element) in (DataLoaderImpl.shared.places).enumerated() {
            let element1 = element.category
            let element2 = element.name
            let element3 = element.url
            let element4 = element.description
            let newStr = element1 + element2 + element3 + element4
            if newStr.smartContains(searchReq) {
                newData.append(element)
            }
        }
        newData.remove(at: 0)
        DataLoaderImpl.shared.places = newData
        MapViewController.isSearching = true
        DispatchQueue.main.async {
            if let topVC = UIApplication.getTopViewController() {
                topVC.present(DI.shared.getMapViewController_Map(), animated: true)
            }
        }

    }
    private func cardSearch(categories: [String]) {
        var newData = [Places]()
        for (index, element) in (DataLoaderImpl.shared.places).enumerated() {
            let element1 = element.category
            let element2 = element.name
            let element3 = element.url
            let element4 = element.description
            let newStr = element1 + element2 + element3 + element4
            for i in categories {
                if newStr.smartContains(i) {
                    newData.append(element)
                }
            }
        }
        newData.remove(at: 0)
        DataLoaderImpl.shared.placesSearch = newData
        CardsViewPresenter.isSearching = true
    }

    func enteredApp() {

        self.delegate?.mainViewPresenter(self, isLoading: true)

        let cache = CacheImpl.shared

        let authService = DI.shared.getAuthSerivce()

        var idToken = cache.getSecret(key: "idToken")
        var refreshToken = cache.getSecret(key: "refreshToken")

        if idToken == "ID" {
            authService.setIsAuthDebug(newValue: true)
        }

        if !DI.tinkoffId.isTinkoffAuthAvailable && !authService.getIsAuthDebug() {
            self.delegate?.mainViewPresenter(self, isLoading: false)
            goToLogin()
        } else if authService.getIsAuthDebug() {
            DataLoaderImpl.shared.loadData()
        } else {

            if idToken != "" {
                DI.tinkoffId.obtainTokenPayload(using: refreshToken, handleRefreshToken)
            } else {
                self.delegate?.mainViewPresenter(self, isLoading: false)
                goToLogin()
            }

        }
    }

    private func handleRefreshToken(_ result: Result<TinkoffTokenPayload, TinkoffAuthError>) {
        do {
            let credentials = try result.get()
            let cache = CacheImpl.shared

            cache.setSecret(key: "idToken", value: credentials.idToken)
            cache.setSecret(key: "accessToken", value: credentials.accessToken)
            cache.setSecret(key: "refreshToken", value: credentials.refreshToken ?? "")

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

                    if let jsonArray = try? JSONSerialization.jsonObject(with: String(data: data, encoding: .utf8)?
                        .data(using: .utf8) ?? Data(), options: .allowFragments) as? [Dictionary<String, Any>] {

                        if jsonArray.count > 0 {
                            cache.setSecret(key: "idToken", value: jsonArray[0]["TID_ID"] as? String ?? "")
                            cache.setSecret(key: "accessToken", value: jsonArray[0]["TID_AccessToken"] as? String ?? "")
                            cache.setPreferences(data: jsonArray[0]["firstName"] as? String ?? "", forKey: "firstName")
                            cache.setPreferences(data: jsonArray[0]["lastName"] as? String ?? "", forKey: "lastName")
                            cache.setPreferences(data: jsonArray[0]["isAdmin"] as? Bool ?? false, forKey: "isAdmin")
                            cache.setPreferences(data: jsonArray[0]["achievements"] as? String ?? "", forKey: "achievements")
                            if !DataLoaderImpl.shared.loadData() {
                                self.goToLogin()
                            }
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
