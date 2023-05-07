//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 18.04.2023.
//

import Foundation

final class OAuth2Service: OAuth2ServiceProtocol {
    
    static let shared = OAuth2Service()
    
    private let decoder = JSONDecoder()
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
        
        guard var urlComponents = URLComponents(string: Constants.unsplashTokenURL) else {
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else {
            assertionFailure("Failed to create URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = fetchDataTask(for: request) { result in
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
        task.resume()
    }
}

private extension OAuth2Service {
    func fetchDataTask(
        for request: URLRequest,
        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
    ) -> URLSessionDataTask {
        session.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
                Result {
                    try self.decoder.decode(OAuthTokenResponseBody.self, from: data)
                }
            }
            completion(response)
        }
    }
}
