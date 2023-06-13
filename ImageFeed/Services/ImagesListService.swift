//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 16.05.2023.
//

import Foundation

protocol ImagesListServiceProtocol {
    var photos: [Photo] { get }
    func fetchPhotosNextPage(completion: @escaping (Result<[Photo], Error>) -> Void)
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
}

final class ImagesListService: ImagesListServiceProtocol {
    
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private let session = URLSession.shared
    private let token = OAuth2TokenStorage.shared.token
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    
    func fetchPhotosNextPage(completion: @escaping (Result<[Photo], Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil { return }
        
        let nextPage: Int
        if let lastLoadedPage {
            nextPage = lastLoadedPage + 1
        } else {
            nextPage = 1
        }
        
        guard let request = photoRequest(for: nextPage) else { return }
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let photoResult):
                self.lastLoadedPage = nextPage
                photoResult.forEach { onePhotoResult in
                    self.photos.append(self.convertPhoto(from: onePhotoResult))
                }
                
                NotificationCenter.default
                    .post(
                        name: ImagesListService.didChangeNotification,
                        object: self,
                        userInfo: ["URL" : photos.count]
                    )
            case .failure(let error):
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
    }
    
    func changeLike(
        photoId: String,
        isLike: Bool,
        _ completion: @escaping (Result<Void, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        
        let method = isLike ? "POST" : "DELETE"
        
        guard let request = changeLikeRequest(for: photoId, with: method) else { return }
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<PhotoLikeResult, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(_):
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    let photo = self.photos[index]
                    self.photos[index].isLiked = !photo.isLiked
                    completion(.success(()))
                }
            case .failure(let error):
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
    }
}

private extension ImagesListService {
    
    func photoRequest(for nextPage: Int) -> URLRequest? {
        guard let token = token else {
            assert(token == nil, "Failed to get token")
            return nil
        }
        
        var request = URLRequest.makeRequest(
            path: "/photos"
            + "?page=\(nextPage)",
            httpMethod: "GET"
        )
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    func changeLikeRequest(for photoId: String, with httpMethod: String) -> URLRequest? {
        guard let token = token else {
            assert(token == nil, "Failed to get token")
            return nil
        }
        
        var request = URLRequest.makeRequest(
            path: "/photos/\(photoId)/like",
            httpMethod: httpMethod
        )
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    func convertPhoto(from photoResult: PhotoResult) -> Photo {
        Photo(
            id: photoResult.id,
            size: CGSize(width: photoResult.width, height: photoResult.height),
            createdAt: Date.convertStringToDate(photoResult.createdAt ?? String()),
            welcomeDescription: photoResult.description,
            thumbImageURL: photoResult.urls.thumb,
            largeImageURL: photoResult.urls.full,
            isLiked: photoResult.likedByUser
        )
    }
}
