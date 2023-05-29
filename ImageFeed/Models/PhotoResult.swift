//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 16.05.2023.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    let likedByUser: Bool
    let description: String?
    let urls: UrlsResult
}

struct UrlsResult: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct PhotoLikeResult: Decodable {}
