//
//  ProfileImageServiceProtocol.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 08.05.2023.
//

import Foundation

protocol ProfileImageServiceProtocol {
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void)
}
