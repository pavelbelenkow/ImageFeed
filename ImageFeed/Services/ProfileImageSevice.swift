//
//  ProfileImageSevice.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 08.05.2023.
//

import Foundation

final class ProfileImageService: ProfileImageServiceProtocol {
    
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private let session = URLSession.shared
    private var task: URLSessionTask?
    private (set) var avatarURL: String?
    
    func fetchProfileImageURL(
        token: String,
        username: String,
        _ completion: @escaping (Result<String, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        if task != nil {
            task?.cancel()
            return
        }
        
        guard let request = profileImageRequest(token, username) else { return }
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let body):
                let avatarURL = body.profileImage.small
                self.avatarURL = avatarURL
                completion(.success(avatarURL))
                
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": avatarURL]
                    )
            case .failure(let error):
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
    }
}

private extension ProfileImageService {
    func profileImageRequest(_ token: String, _ username: String) -> URLRequest? {
        var request = URLRequest.makeRequest(
            path: "/users/\(username)",
            httpMethod: "GET"
        )
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
