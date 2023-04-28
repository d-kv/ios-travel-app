//
//  LoginViewPresenter.swift
//  Tinkoff Travel
//
//  Created by Евгений Парфененков on 02.03.2023.
//

import Foundation
import UIKit
import TinkoffID

// MARK: - Protocols

protocol LoginViewPresenterDelegate: AnyObject {
    func loginViewPresenter(_ reposViewModel: LoginViewPresenter,
                            isLoading: Bool)
    func TinkoffIDResolver(status: StatusCodes)
}

// MARK: - Main methods and Class

class LoginViewPresenter {

    weak var delegate: LoginViewPresenterDelegate?

    private let authService = DI.shared.getAuthService()
    private let cache = CacheImpl.shared

    @objc func authButtonClicked() {
        delegate?.TinkoffIDResolver(status: StatusCodes.proceed)
        DI.shared.getAuthService().tinkoffIDAuth(handler: handleSignInResult)
    }

    private func goToMain() {
        let mainViewController = DI.shared.getMainViewController()

        mainViewController.modalPresentationStyle = .fullScreen

        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        sceneDelegate.window!.rootViewController?.present(mainViewController, animated: true)
        sceneDelegate.window!.rootViewController?.dismiss(animated: true)
    }

    // MARK: - Auth handler

    private var credentials: TinkoffTokenPayload?

    private func handleSignInResult(_ result: Result<TinkoffTokenPayload, TinkoffAuthError>) {
        do {
            credentials = try result.get()
            cache.setIdToken(value: credentials?.idToken ?? "")
            cache.setAccessToken(value: credentials?.accessToken ?? "")
            cache.setRefreshToken(value: credentials?.refreshToken ?? "")

            req()

        } catch TinkoffAuthError.cancelledByUser {
            delegate?.TinkoffIDResolver(status: StatusCodes.cancelledByUser)
        } catch TinkoffAuthError.failedToLaunchApp {
            delegate?.TinkoffIDResolver(status: StatusCodes.failedToLaunch)
        } catch TinkoffAuthError.failedToObtainToken {
            delegate?.TinkoffIDResolver(status: StatusCodes.failedToObtainToken)
        } catch TinkoffAuthError.unavailable {
            delegate?.TinkoffIDResolver(status: StatusCodes.unavailable)
        } catch {
            delegate?.TinkoffIDResolver(status: StatusCodes.unknownError)
        }
    }

    private func prepareReq() -> URLRequest {
        var idToken = cache.getIdToken()
        var accessToken = cache.getAccessToken()

        var host = ""
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
            let keys = NSDictionary(contentsOfFile: path) ?? NSDictionary()
            host = keys["HOST"] as? String ?? ""
        }

        let url = URL(string: host + "/api/auth?tid_id=" + idToken + "&tid_accessToken=" + accessToken)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        
        return request
    }
    
    private func req() {
        let task = URLSession.shared.dataTask(with: prepareReq()) { data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
            else {                                                               // check for fundamental networking error
                DispatchQueue.main.async { self.delegate?.TinkoffIDResolver(status: .someError) }
                return
            }

            switch response.statusCode {
            case 200: // success

                if let jsonArray = try? JSONSerialization.jsonObject(with: String(data: data, encoding: .utf8)?.data(using: .utf8) ?? Data(), options: .allowFragments) as? [Dictionary<String, Any>] {
                    if jsonArray.count > 0 {
                        self.cache.setIdToken(value: jsonArray[0]["TID_ID"] as? String ?? "")
                        self.cache.setAccessToken(value: jsonArray[0]["TID_AccessToken"] as? String ?? "")
                        self.cache.setPreferences(data: jsonArray[0]["firstName"] as? String ?? "", forKey: "firstName")
                        self.cache.setPreferences(data: jsonArray[0]["lastName"] as? String ?? "", forKey: "lastName")
                        self.cache.setPreferences(data: jsonArray[0]["isAdmin"] as? Bool ?? false, forKey: "isAdmin")
                        self.cache.setPreferences(data: jsonArray[0]["achievements"] as? String ?? "", forKey: "achievements")
                        DispatchQueue.main.async {
                            self.delegate?.TinkoffIDResolver(status: .waiting)
                            self.goToMain()
                        }
                    } else {
                        DispatchQueue.main.async { self.delegate?.TinkoffIDResolver(status: .someError) }
                    }
                } else {

                    DispatchQueue.main.async { self.delegate?.TinkoffIDResolver(status: .someError) }
                }
            case 404:
                DispatchQueue.main.async { self.delegate?.TinkoffIDResolver(status: .someError) }
            case 401:
                DispatchQueue.main.async { self.delegate?.TinkoffIDResolver(status: .failTID) }
            case 500:
                DispatchQueue.main.async { self.delegate?.TinkoffIDResolver(status: .serverError) }
            case 207:
                DispatchQueue.main.async { self.delegate?.TinkoffIDResolver(status: .notTester) }
            case 403:
                DispatchQueue.main.async { self.delegate?.TinkoffIDResolver(status: .blocked) }
            default:
                DispatchQueue.main.async { self.delegate?.TinkoffIDResolver(status: .someError) }
            }
        }
        task.resume()
    }

    func debug_req(TIN_accessToken: String) {
        var host = ""
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
            let keys = NSDictionary(contentsOfFile: path) ?? NSDictionary()
            host = keys["HOST"] as? String ?? ""
        }

        let url = URL(string: host + "/api/auth?tid_id=ID&tid_accessToken=" + TIN_accessToken + "&debug=1")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
            else {                                                               // check for fundamental networking error
                DispatchQueue.main.async { self.delegate?.TinkoffIDResolver(status: .someError) }
                return
            }

            switch response.statusCode {
            case 200: // success

                if let jsonArray = try? JSONSerialization.jsonObject(with: String(data: data, encoding: .utf8)?.data(using: .utf8) ?? Data(), options: .allowFragments) as? [Dictionary<String, Any>] {

                    self.cache.setIdToken(value: jsonArray[0]["TID_ID"] as? String ?? "")
                    self.cache.setAccessToken(value: jsonArray[0]["TID_AccessToken"] as? String ?? "")
                    self.cache.setPreferences(data: jsonArray[0]["firstName"] as? String ?? "", forKey: "firstName")
                    self.cache.setPreferences(data: jsonArray[0]["lastName"] as? String ?? "", forKey: "lastName")
                    self.cache.setPreferences(data: jsonArray[0]["isAdmin"] as? Bool ?? false, forKey: "isAdmin")
                    self.cache.setPreferences(data: jsonArray[0]["achievements"] as? String ?? "", forKey: "achievements")

                    self.authService.setIsAuthDebug(newValue: true)

                    DispatchQueue.main.async {
                        self.delegate?.TinkoffIDResolver(status: .waiting)
                        self.goToMain()
                    }
                } else {
                    DispatchQueue.main.async { self.delegate?.TinkoffIDResolver(status: .someError) }
                }
            default:
                DispatchQueue.main.async { self.delegate?.TinkoffIDResolver(status: .someError) }
            }
        }
        task.resume()
    }
}

enum StatusCodes {
    case waiting
    case proceed
    case failedToLaunch
    case cancelledByUser
    case unavailable
    case failedToObtainToken
    case failedToRefreshCredentials
    case unknownError
    case someError
    case failTID
    case serverError
    case notTester
    case blocked
}
