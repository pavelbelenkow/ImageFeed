//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 01.05.2023.
//

import Foundation

final class ProfileService: ProfileServiceProtocol {
    
    static let shared = ProfileService()
    
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
        
        guard let request = profileRequest(token) else { return }
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let body):
                profile = convertProfileResult(from: body)
                guard let profile = profile else { return }
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
    }
}

private extension ProfileService {
    
    func profileRequest(_ token: String) -> URLRequest? {
        var request = URLRequest.makeHTTPRequest(
            baseURL: Constants.defaultBaseURL,
            path: "/me",
            httpMethod: "GET"
        )
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    func convertProfileResult(from profile: ProfileResult) -> Profile {
        Profile(
            username: profile.username,
            name: profile.firstName + " " + (profile.lastName ?? String()),
            loginName: "@" + profile.username,
            bio: profile.bio ?? String()
        )
    }
}
