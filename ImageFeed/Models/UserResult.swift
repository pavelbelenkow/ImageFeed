//
//  UserResult.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 08.05.2023.
//

import Foundation

struct UserResult: Decodable {
    let profileImage: Image
}

struct Image: Decodable {
    let small: String
}
