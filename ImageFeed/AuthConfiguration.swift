//
//  Constants.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 13.04.2023.
//

import Foundation

enum Constants {
    static let accessKey = "dQ5aZhE3fSPw9rxynMPyZMbfixaMuLV4Q868evoQeYY"
    static let secretKey = "qVtphx3u6MVKUS6bdI7KfJodHiVr0GMusPEtF1C31qw"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseString = "https://api.unsplash.com"
    static let unsplashAuthorizeString = "https://unsplash.com/oauth/authorize"
    static let unsplashTokenString = "https://unsplash.com/oauth/token"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: String
    let authURLString: String
    let tokenURLString: String
    
    init(
        accessKey: String,
        secretKey: String,
        redirectURI: String,
        accessScope: String,
        defaultBaseURL: String,
        authURLString: String,
        tokenURLString: String
    ) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
        self.tokenURLString = tokenURLString
    }
    
    static var standard: AuthConfiguration {
        AuthConfiguration(
            accessKey: Constants.accessKey,
            secretKey: Constants.secretKey,
            redirectURI: Constants.redirectURI,
            accessScope: Constants.accessScope,
            defaultBaseURL: Constants.defaultBaseString,
            authURLString: Constants.unsplashAuthorizeString,
            tokenURLString: Constants.unsplashTokenString)
    }
}
