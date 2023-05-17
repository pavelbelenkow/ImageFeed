//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 16.05.2023.
//

import Foundation

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
        if task != nil {
            task?.cancel()
            return
        }
    
        guard let request = photoRequest() else { return }
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let photoResult):
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
}

private extension ImagesListService {
    
    func photoRequest() -> URLRequest? {
        if var lastLoadedPage = lastLoadedPage {
            lastLoadedPage += 1
        } else {
            lastLoadedPage = 1
        }
        
        guard var urlComponents = URLComponents(string: Constants.defaultBaseURL) else {
            assertionFailure("Failed to get URL from String")
            return nil
        }
        urlComponents.path = "/photos"
        urlComponents.queryItems = [URLQueryItem(name: "page", value: String(lastLoadedPage ?? 1))]
        
        guard let url = urlComponents.url,
              let token = token else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    func convertPhoto(from photoResult: PhotoResult) -> Photo {
        Photo(
            id: photoResult.id,
            size: CGSize(width: photoResult.width, height: photoResult.height),
            createdAt: ISO8601DateFormatter().date(from: photoResult.createdAt),
            welcomeDescription: photoResult.description,
            thumbImageURL: photoResult.urls.thumb,
            largeImageURL: photoResult.urls.full,
            isLiked: photoResult.likedByUser
        )
    }
}
