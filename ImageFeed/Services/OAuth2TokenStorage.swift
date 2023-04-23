//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 18.04.2023.
//

import Foundation

final class OAuth2TokenStorage {
    
    private enum Keys: String {
        case bearerToken
    }
    
    private let userDefaults = UserDefaults.standard
    
    var token: String? {
        get {
            userDefaults.string(forKey: Keys.bearerToken.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.bearerToken.rawValue)
        }
    }
}
