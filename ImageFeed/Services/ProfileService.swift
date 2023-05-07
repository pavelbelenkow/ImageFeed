//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 01.05.2023.
//

import Foundation

final class ProfileService: ProfileServiceProtocol {
    
    static let shared = ProfileService()
    
    private let decoder = JSONDecoder()
    private let session = URLSession.shared
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    
    func fetchProfile(
        _ token: String,
        completion: @escaping (Result<Profile, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        if task != nil {
            task?.cancel()
            return
        }
        
        guard var urlComponents = URLComponents(string: Constants.defaultBaseURL) else {
            return
        }
        urlComponents.path = "/me"
        
        guard let url = urlComponents.url else {
            assertionFailure("Failed to create URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = fetchDataTask(for: request) { result in
            switch result {
            case .success(let body):
                self.profile = self.convertProfileResult(from: body)
                guard let profile = self.profile else { return }
                completion(.success(profile))
            case.failure(let error):
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
}

private extension ProfileService {
    func convertProfileResult(from profile: ProfileResult) -> Profile {
        Profile(
            username: profile.username,
            name: profile.firstName + " " + profile.lastName,
            loginName: "@" + profile.username,
            bio: profile.bio ?? String()
        )
    }
    
    func fetchDataTask(
        for request: URLRequest,
        completion: @escaping (Result<ProfileResult, Error>) -> Void
    ) -> URLSessionDataTask {
        session.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<ProfileResult, Error> in
                Result {
                    try self.decoder.decode(ProfileResult.self, from: data)
                }
            }
            completion(response)
        }
    }
}
