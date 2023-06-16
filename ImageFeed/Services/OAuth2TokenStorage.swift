//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 18.04.2023.
//

import Foundation
import SwiftKeychainWrapper

protocol OAuth2TokenStorageProtocol: AnyObject {
    var token: String? { get set }
    func removeToken()
}

final class OAuth2TokenStorage: OAuth2TokenStorageProtocol {
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
    
    func removeToken() {
        keychainWrapper.removeObject(forKey: Keys.bearerToken.rawValue)
    }
}
