//
//  URLRequest+Extensions.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 13.05.2023.
//

import Foundation

extension URLRequest {
    static func makeRequest(
        baseURL: String = Constants.defaultBaseURL,
        path: String,
        httpMethod: String
    ) -> URLRequest? {
        guard
            let urlFromString = URL(string: baseURL),
            let url = URL(string: path, relativeTo: urlFromString)
        else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        
        return request
    }
}
