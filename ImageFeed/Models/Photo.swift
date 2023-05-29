//
//  Photo.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 16.05.2023.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String?
    let largeImageURL: String?
    var isLiked: Bool
}
