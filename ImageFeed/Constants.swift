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
    static let defaultBaseURL = "https://api.unsplash.com"
    static let unsplashAuthorizeURL = "https://unsplash.com/oauth/authorize"
    static let unsplashTokenURL = "https://unsplash.com/oauth/token"
}
