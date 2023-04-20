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
    
    func getIsAuthDebug() -> Bool
    func setIsAuthDebug(newValue: Bool)
}

class AuthServiceImpl: AuthService {
    
    
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
    
    func getIsAuthDebug() -> Bool {
        return isAuthDebug
    }
    
    func setIsAuthDebug(newValue: Bool) {
        isAuthDebug = newValue
    }
    
    private var isAuthDebug = false
}
