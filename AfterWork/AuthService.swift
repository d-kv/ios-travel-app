//
//  AuthService.swift
//  AfterWork
//
//  Created by Евгений Парфененков on 14.03.2023.
//

import Foundation
import TinkoffID

class AuthService {
    
    static var isAuthDebug = false
    
    static var tinkoffId: ITinkoffID = {
        
        var clientId = ""
        var callbackUrl = ""
        
        var keys = NSDictionary()
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)!
            
            clientId = keys["CLIENT_ID"] as! String
            callbackUrl = keys["CALLBACK_URI"] as! String
        }
        
        
        let factory = TinkoffIDFactory(
            clientId: clientId,
            callbackUrl: callbackUrl
        )
        
        return factory.build()
    }()
    
    static var debugTinkoffId: ITinkoffID = {
        let callbackUrl = "afterwork://"
        
        let configuration = DebugConfiguration(
            canRefreshTokens: true,
            canLogout: true
        )
        
        let factory = DebugTinkoffIDFactory(
            callbackUrl: callbackUrl,
            configuration: configuration
        )
        
        return factory.build()
    }()
        
    func TinkoffIDAuth(handler: @escaping SignInCompletion) {
        
        if AuthService.tinkoffId.isTinkoffAuthAvailable {
            AuthService.tinkoffId.startTinkoffAuth(handler)
        } else {
            AuthService.debugTinkoffId.startTinkoffAuth(handler)
        }
    }
    
    func refreshToken(refreshToken: String, handler: @escaping SignInCompletion) {
        
        if AuthService.tinkoffId.isTinkoffAuthAvailable {
            AuthService.tinkoffId.obtainTokenPayload(using: refreshToken, handler)
        } else {
            AuthService.debugTinkoffId.obtainTokenPayload(using: refreshToken, handler)
        }
    }
    
    func logOut(accessToken: String, handler: @escaping SignOutCompletion) {
        if AuthService.tinkoffId.isTinkoffAuthAvailable {
            AuthService.tinkoffId.signOut(with: accessToken, tokenTypeHint: .access, completion: handler)
        } else {
            AuthService.debugTinkoffId.signOut(with: accessToken, tokenTypeHint: .access, completion: handler)
        }
    }
    
    
    static func getSecret(key: String) -> String {
        var secret = ""
        
        let keychainItemIdToken = [kSecClass: kSecClassGenericPassword, kSecReturnAttributes: true,
                              kSecReturnData: true, kSecAttrAccount: key] as CFDictionary
        var refIdToken: AnyObject?
        let statusIdToken = SecItemCopyMatching(keychainItemIdToken, &refIdToken)
        if let result = refIdToken as? NSDictionary, let passwordData = result[kSecValueData] as? Data {
            let str = String(decoding: passwordData, as: UTF8.self)
            secret = str
        }
        return secret
    }
    
    static func setSecret(key: String, value: String) {
        SecItemDelete([kSecClass: kSecClassGenericPassword, kSecAttrAccount: key] as CFDictionary)
        SecItemAdd([kSecValueData: value.data(using: .utf8), kSecClass: kSecClassGenericPassword, kSecAttrAccount: key] as CFDictionary, nil)
    }
}
