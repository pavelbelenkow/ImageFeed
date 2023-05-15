//
//  URLRequest+Extensions.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 13.05.2023.
//

import Foundation

extension URLRequest {
    static func makeHTTPRequest(
        baseURL: String,
        path: String,
        httpMethod: String
    ) -> URLRequest? {
        guard var urlComponents = URLComponents(string: baseURL) else {
            assertionFailure("Failed to get URL from String")
            return nil
        }
        urlComponents.path = path
        
        guard let url = urlComponents.url else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}
