//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 18.04.2023.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
}
