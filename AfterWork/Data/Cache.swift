//
//  Cache.swift
//  AfterWork
//
//  Created by Евгений Парфененков on 19.04.2023.
//

import Foundation

protocol Cache {
    func getSecret(key: String) -> String
    func setSecret(key: String, value: String)
}

class CacheImpl: Cache {
    
    static let shared = CacheImpl()
    
    func getSecret(key: String) -> String {
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
    
    func setSecret(key: String, value: String) {
        SecItemDelete([kSecClass: kSecClassGenericPassword, kSecAttrAccount: key] as CFDictionary)
        SecItemAdd([kSecValueData: value.data(using: .utf8), kSecClass: kSecClassGenericPassword, kSecAttrAccount: key] as CFDictionary, nil)
    }
    
}
