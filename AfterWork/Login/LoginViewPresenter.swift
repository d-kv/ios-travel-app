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
    func TinkoffIDResolver(status: StatusCodes) // 0 - waiting; 1 - auth process; 2 - success login; 3 - login canceled; 4 - login failed; 5 - some mistake
}

// MARK: - Main methods and Class

class LoginViewPresenter {

    weak var delegate: LoginViewPresenterDelegate?
    
    let preferences = UserDefaults.standard
    
    @objc func authButtonClicked() {
        delegate?.TinkoffIDResolver(status: StatusCodes.proceed)
        DI.shared.getAuthSerivce().TinkoffIDAuth(handler: handleSignInResult)
    }
    
    private func goToMain() {
        let mainViewController = DI.shared.getMainViewController()
        
        mainViewController.modalPresentationStyle = .fullScreen
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        sceneDelegate.window!.rootViewController?.present(mainViewController, animated: true)
        sceneDelegate.window!.rootViewController?.dismiss(animated: true)
    }
    
    // MARK: - Auth handler
    
    private var credentials: TinkoffTokenPayload!
    
    private func handleSignInResult(_ result: Result<TinkoffTokenPayload, TinkoffAuthError>) {
        do {
            credentials = try result.get()
            AuthService.setSecret(key: "idToken", value: credentials.idToken)
            AuthService.setSecret(key: "accessToken", value: credentials.accessToken)
            AuthService.setSecret(key: "refreshToken", value: credentials.refreshToken!)

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
    
    private func req() {
        
        var idToken = AuthService.getSecret(key: "idToken")
        var accessToken = AuthService.getSecret(key: "accessToken")
                
        let url = URL(string: "http://82.146.33.253:8000/api/auth?tid_id=" + idToken + "&tid_accessToken=" + accessToken)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        
        print("debug: ", idToken)
        print("debug: ", accessToken)
        print("debug: ", AuthService.getSecret(key: "refreshToken"))
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
            else {                                                               // check for fundamental networking error
                DispatchQueue.main.async { self.delegate?.TinkoffIDResolver(status: .someError) }
                print("debug15")
                return
            }

            switch response.statusCode {
            case 200: // success
                
                if let jsonArray = try? JSONSerialization.jsonObject(with: String(data: data, encoding: .utf8)!.data(using: .utf8)!, options : .allowFragments) as? [Dictionary<String,Any>] {
//                    self.preferences.set(jsonArray[0]["TID_ID"] as! String, forKey: "idToken")
//                    self.preferences.set(jsonArray[0]["TID_AccessToken"] as! String, forKey: "accessToken")
                    AuthService.setSecret(key: "idToken", value: jsonArray[0]["TID_ID"] as! String)
                    AuthService.setSecret(key: "accessToken", value: jsonArray[0]["TID_AccessToken"] as! String)
                    self.preferences.set(jsonArray[0]["firstName"] as! String, forKey: "firstName")
                    self.preferences.set(jsonArray[0]["lastName"] as! String, forKey: "lastName")
                    self.preferences.set(jsonArray[0]["isAdmin"] as! Bool, forKey: "isAdmin")
                    self.preferences.set(jsonArray[0]["achievements"] as! String, forKey: "achievements")
                    DispatchQueue.main.async {
                        self.delegate?.TinkoffIDResolver(status: .waiting)
                        self.goToMain()
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
        
        let url = URL(string: "http://82.146.33.253:8000/api/auth?tid_id=ID&tid_accessToken=" + TIN_accessToken + "&debug=1")!
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
                print("debug14")
                return
            }

            switch response.statusCode {
            case 200: // success
                
                if let jsonArray = try? JSONSerialization.jsonObject(with: String(data: data, encoding: .utf8)!.data(using: .utf8)!, options : .allowFragments) as? [Dictionary<String,Any>] {
                    print(jsonArray[0])
//                    self.preferences.set(jsonArray[0]["TID_ID"] as! String, forKey: "idToken")
//                    self.preferences.set(jsonArray[0]["TID_AccessToken"] as! String, forKey: "accessToken")
                    AuthService.setSecret(key: "idToken", value: jsonArray[0]["TID_ID"] as! String)
                    AuthService.setSecret(key: "accessToken", value: jsonArray[0]["TID_AccessToken"] as! String)
                    self.preferences.set(jsonArray[0]["firstName"] as! String, forKey: "firstName")
                    self.preferences.set(jsonArray[0]["lastName"] as! String, forKey: "lastName")
                    self.preferences.set(jsonArray[0]["isAdmin"] as! Bool, forKey: "isAdmin")
                    self.preferences.set(jsonArray[0]["achievements"] as! String, forKey: "achievements")
                    
                    AuthService.isAuthDebug = true
                    
                    DispatchQueue.main.async {
                        self.delegate?.TinkoffIDResolver(status: .waiting)
                        self.goToMain()
                        print("debug13")
                    }
                } else {
                    DispatchQueue.main.async { self.delegate?.TinkoffIDResolver(status: .someError) }
                    print("debug12")
                }
            default:
                DispatchQueue.main.async { self.delegate?.TinkoffIDResolver(status: .someError) }
                print("debug11")
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
    case someError//                case 404: // some error
    case failTID//                case 401: // failed to auth TID
    case serverError//                case 500: // server error
    case notTester//                case 207: // not tester
    case blocked//                case 403: // blocked
}

//                case 404: // some error
//                case 401: // failed to auth TID
//                case 500: // server error
//                case 207: // not tester
//                case 403: // blocked
