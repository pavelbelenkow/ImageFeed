//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 04.06.2023.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest?
    func code(from url: URL) -> String?
}

final class AuthHelper: AuthHelperProtocol {
    private let configuration: AuthConfiguration
    
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
    
    func authRequest() -> URLRequest? {
        guard let url = authURL() else {
            assert(authURL() == nil, "Failed to get AuthURL")
            return nil
        }
        return URLRequest(url: url)
    }
    
    func authURL() -> URL? {
        guard var urlComponents = URLComponents(string: Constants.unsplashAuthorizeString) else {
            assert(URLComponents(string: Constants.unsplashAuthorizeString) == nil, "Failed to get Unsplash authorize string")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        guard let url = urlComponents.url else {
            assert(urlComponents.url == nil, "Failed to get authorization URL")
            return nil
        }
        
        return url
    }
    
    func code(from url: URL) -> String? {
        if
            let urlComponent = URLComponents(string: url.absoluteString),
            urlComponent.path == "/oauth/authorize/native",
            let items = urlComponent.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
