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
    
    private let decoder = JSONDecoder()
    private let session = URLSession.shared
    private let token = OAuth2TokenStorage.shared.token
    private var task: URLSessionTask?
    private (set) var avatarURL: String?
    
    func fetchProfileImageURL(
        username: String,
        _ completion: @escaping (Result<String, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        if task != nil {
            task?.cancel()
            return
        }
        
        guard var urlComponents = URLComponents(string: Constants.defaultBaseURL) else {
            return
        }
        urlComponents.path = "/users/\(username)"
        
        guard let url = urlComponents.url else {
            assertionFailure("Failed to create URL")
            return
        }
        
        var request = URLRequest(url: url)
        guard let token else { return }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = fetchDataTask(for: request) { result in
            switch result {
            case .success(let profile):
                self.avatarURL = profile.profileImage.small
                guard let avatarURL = self.avatarURL else { return }
                completion(.success(avatarURL))
                
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": avatarURL])
            case .failure(let error):
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
}

private extension ProfileImageService {
    func fetchDataTask(
        for request: URLRequest,
        completion: @escaping (Result<UserResult, Error>) -> Void
    ) -> URLSessionDataTask {
        session.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<UserResult, Error> in
                Result {
                    try self.decoder.decode(UserResult.self, from: data)
                }
            }
            completion(response)
        }
    }
}
