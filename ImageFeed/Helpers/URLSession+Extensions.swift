//
//  URLSession+Extensions.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 21.04.2023.
//

import Foundation

private enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    func objectTask<T>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask where T: Decodable {
        
        let fulfillCompletion: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request) { data, response, error in
            if let data = data,
               let response = response as? HTTPURLResponse
            {
                if 200 ..< 300 ~= response.statusCode {
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        
                        let result = try decoder.decode(T.self, from: data)
                        fulfillCompletion(.success(result))
                    } catch {
                        fulfillCompletion(.failure(error))
                    }
                } else {
                    fulfillCompletion(.failure(NetworkError.httpStatusCode(response.statusCode)))
                }
            } else if let error = error {
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletion(.failure(NetworkError.urlSessionError))
            }
        }
        task.resume()
        return task
    }
}
