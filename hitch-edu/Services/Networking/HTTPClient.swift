//
//  HTTPClient.swift
//  hitch-edu
//
//  Created by Godson Umoren on 11/20/24.
//

import Foundation
import Combine

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

class HTTPClient {
    func execute<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, APIError> {
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result -> Data in
                guard let response = result.response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                guard (200...299).contains(response.statusCode) else {
                    throw APIError.serverError(response.statusCode)
                }
                return result.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> APIError in
                if let apiError = error as? APIError {
                    return apiError
                } else if let decodingError = error as? DecodingError {
                    return APIError.decodingError(decodingError)
                } else {
                    return APIError.unknown(error)
                }
            }
            .eraseToAnyPublisher()
    }
}

