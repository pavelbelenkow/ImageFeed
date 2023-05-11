//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 18.04.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    
    private enum Keys: String {
        case bearerToken
    }
    
    private let keychainWrapper = KeychainWrapper.standard
    
    var token: String? {
        get {
            keychainWrapper.string(forKey: Keys.bearerToken.rawValue)
        }
        set {
            if let newValue {
                keychainWrapper.set(newValue, forKey: Keys.bearerToken.rawValue)
            } else {
                keychainWrapper.removeObject(forKey: Keys.bearerToken.rawValue)
            }
        }
    }
    
    private init() { }
}
