//
//  UserResult.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 08.05.2023.
//

import Foundation

struct UserResult: Decodable {
    let profileImage: Image
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct Image: Decodable {
    let small: String
}
