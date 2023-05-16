//
//  ImagesListServiceProtocol.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 16.05.2023.
//

import Foundation

protocol ImagesListServiceProtocol {
    func fetchPhotosNextPage(completion: @escaping (Result<Photo, Error>) -> Void)
}
