//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 18.04.2023.
//

import Foundation

protocol OAuth2ServiceProtocol {
    func fetchAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void)
}

final class OAuth2Service: OAuth2ServiceProtocol {
    
    static let shared = OAuth2Service()
    
    private let session = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    func fetchAuthToken(
        _ code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        
        guard let request = oauth2Request(code) else { return }
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let body):
                completion(.success(body.accessToken))
            case .failure(let error):
                completion(.failure(error))
                self.lastCode = nil
            }
            self.task = nil
        }
        self.task = task
    }
}

private extension OAuth2Service {
    func oauth2Request(_ code: String) -> URLRequest? {
        URLRequest.makeRequest(
            baseURL: Constants.unsplashTokenURL,
            path:
              "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST"
        )
    }
}
