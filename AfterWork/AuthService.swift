//
//  AuthService.swift
//  AfterWork
//
//  Created by Евгений Парфененков on 14.03.2023.
//

import Foundation
import TinkoffID

protocol AuthService {
    func tinkoffIDAuth(handler: @escaping SignInCompletion)
    func refreshToken(refreshToken: String, handler: @escaping SignInCompletion)
    func logOut(accessToken: String, handler: @escaping SignOutCompletion)
    
    //func getTinkoffId() -> ITinkoffID
    //func getDebugTinkoffId() -> TinkoffID.ITinkoffID
    
    func getIsAuthDebug() -> Bool
    func setIsAuthDebug(newValue: Bool)
}

class AuthServiceImpl: AuthService {
    
    //static let shared = AuthServiceImpl()
    
    func tinkoffIDAuth(handler: @escaping TinkoffID.SignInCompletion) {
        if DI.tinkoffId.isTinkoffAuthAvailable { DI.tinkoffId.startTinkoffAuth(handler) }
        else { DI.debugTinkoffId.startTinkoffAuth(handler) }
    }
    
    func refreshToken(refreshToken: String, handler: @escaping TinkoffID.SignInCompletion) {
        if DI.tinkoffId.isTinkoffAuthAvailable { DI.tinkoffId.obtainTokenPayload(using: refreshToken, handler) }
        else { DI.debugTinkoffId.obtainTokenPayload(using: refreshToken, handler) }
    }
    
    func logOut(accessToken: String, handler: @escaping TinkoffID.SignOutCompletion) {
        if DI.tinkoffId.isTinkoffAuthAvailable { DI.tinkoffId.signOut(with: accessToken, tokenTypeHint: .access, completion: handler) }
        else { DI.debugTinkoffId.signOut(with: accessToken, tokenTypeHint: .access, completion: handler) }
    }
    
//    func getTinkoffId() -> TinkoffID.ITinkoffID {
//        return tinkoffId
//    }
    
//    func getDebugTinkoffId() -> TinkoffID.ITinkoffID {
//        return debugTinkoffId
//    }
    
    func getIsAuthDebug() -> Bool {
        return isAuthDebug
    }
    
    func setIsAuthDebug(newValue: Bool) {
        isAuthDebug = newValue
    }
    
    private var isAuthDebug = false

//    private var tinkoffId: ITinkoffID = {
//
//        var clientId = ""
//        var callbackUrl = ""
//
//        var keys = NSDictionary()
//        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
//            keys = NSDictionary(contentsOfFile: path) ?? NSDictionary()
//
//            clientId = keys["CLIENT_ID"] as? String ?? ""
//            callbackUrl = keys["CALLBACK_URI"] as? String ?? ""
//        }
//
//
//        let factory = TinkoffIDFactory(
//            clientId: clientId,
//            callbackUrl: callbackUrl
//        )
//
//        return factory.build()
//    }()

//    private var debugTinkoffId: ITinkoffID = {
//        let callbackUrl = "afterwork://"
//
//        let configuration = DebugConfiguration(
//            canRefreshTokens: true,
//            canLogout: true
//        )
//
//        let factory = DebugTinkoffIDFactory(
//            callbackUrl: callbackUrl,
//            configuration: configuration
//        )
//
//        return factory.build()
//    }()
}
