//
//  APIService.swift
//  hitch-edu
//
//  Created by Godson Umoren on 11/20/24.
//

import Foundation
import Combine

class APIService {
    private let httpClient = HTTPClient()
    
    // Helper method to make API requests
    func performRequest<T: Decodable>(_ endpoint: String,
                                      method: HTTPMethod,
                                      body: Data? = nil,
                                      headers: [String: String] = [:]) -> AnyPublisher<T, APIError> {
        guard let url = URL(string: endpoint) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        // Add default headers
        var allHeaders = headers
        allHeaders["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = allHeaders
        
        return httpClient.execute(request)
    }
}
