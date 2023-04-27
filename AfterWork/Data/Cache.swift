//
//  Cache.swift
//  AfterWork
//
//  Created by Евгений Парфененков on 19.04.2023.
//

import Foundation

protocol Cache {
//    func getSecret(key: String) -> String
//    func setSecret(key: String, value: String)
    
    func setAccessToken(value: String)
    func setRefreshToken(value: String)
    func setIdToken(value: String)
    
    func getAccessToken() -> String
    func getRefreshToken() -> String
    func getIdToken() -> String

    func parse(json: Data) -> Places

    func setPreferences(data: Any, forKey: String)
    func getPreferences(forKey: String) -> String
    func getPreferencesBool(forKey: String) -> Bool
}

class CacheImpl: Cache {
    
    func setAccessToken(value: String) { setSecret(key: accessTokenKey, value: value) }
    func setRefreshToken(value: String) { setSecret(key: refreshTokenKey, value: value) }
    func setIdToken(value: String) { setSecret(key: idTokenKey, value: value) }
    
    func getAccessToken() -> String { return getSecret(key: accessTokenKey) }
    func getRefreshToken() -> String { return getSecret(key: refreshTokenKey) }
    func getIdToken() -> String { return getSecret(key: idTokenKey) }
    

    static let shared = CacheImpl()

    private let preferences = UserDefaults.standard

    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"
    private let idTokenKey = "idToken"

    private func getSecret(key: String) -> String {
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

    private func setSecret(key: String, value: String) {
        SecItemDelete([kSecClass: kSecClassGenericPassword, kSecAttrAccount: key] as CFDictionary)
        SecItemAdd([kSecValueData: value.data(using: .utf8), kSecClass: kSecClassGenericPassword, kSecAttrAccount: key] as CFDictionary, nil)
    }

    func parse(json: Data) -> Places {
        let decoder = JSONDecoder()
        var place = Places(id: 0, yaid: 0, category: "", name: "", url: "", latitude: "", longitude: "", address: "", description: "", isRecommended: false, phone: "", availability: "")
        do {
            place = try decoder.decode(Places.self, from: json)
            return place
        } catch {
            print("")
        }

        return place
    }

    func setPreferences(data: Any, forKey: String) { preferences.set(data, forKey: forKey) }
    func getPreferences(forKey: String) -> String { return preferences.string(forKey: forKey) ?? "" }
    func getPreferencesBool(forKey: String) -> Bool { return preferences.bool(forKey: forKey) }

}
