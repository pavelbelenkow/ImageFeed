//
//  Constants.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 13.04.2023.
//

import Foundation

enum Constants: String {
    case accessKey = "dQ5aZhE3fSPw9rxynMPyZMbfixaMuLV4Q868evoQeYY"
    case secretKey = "qVtphx3u6MVKUS6bdI7KfJodHiVr0GMusPEtF1C31qw"
    case redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    case accessScope = "public+read_user+write_likes"
    case defaultBaseURL = "https://api.unsplash.com"
    case unsplashAuthorizeURL = "https://unsplash.com/oauth/authorize"
    case unsplashTokenURL = "https://unsplash.com/oauth/token"
}
