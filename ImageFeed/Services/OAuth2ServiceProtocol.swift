//
//  OAuth2ServiceProtocol.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 18.04.2023.
//

import Foundation

protocol OAuth2ServiceProtocol {
    func fetchAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void)
    func fetchDataTask(for request: URLRequest, completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) -> URLSessionDataTask
}
