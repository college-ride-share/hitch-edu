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
        
        // Check if "Content-Type" exists, and only add it if it doesn't
        if allHeaders["Content-Type"] == nil {
            allHeaders["Content-Type"] = "application/json"
        }
        
        // Inject the access token if available
        if let token = KeychainHelper.shared.retrieve(for: "accessToken") {
            allHeaders["Authorization"] = "Bearer \(token)"
        }
        
        request.allHTTPHeaderFields = allHeaders
        
        return httpClient.execute(request)
    }
    
    /// A helper that attempts a request, catches 401 errors, refreshes the token, and retries once.
        func performRequestWithRefresh<T: Decodable>(
            _ endpoint: String,
            method: HTTPMethod,
            body: Data? = nil,
            headers: [String: String] = [:]
        ) -> AnyPublisher<T, APIError> {
            
            // 1. Attempt the request
            return performRequest(endpoint, method: method, body: body, headers: headers)
                
                // 2. Catch errors
                .catch { [weak self] error -> AnyPublisher<T, APIError> in
                    guard let self = self else {
                        return Fail(error: error).eraseToAnyPublisher()
                    }
                    
                    // Only handle serverError(401). Otherwise, just fail.
                    if case .serverError(let statusCode) = error, statusCode == 401 {
                        
                        // 3. Token is invalid/expired. Attempt refresh.
                        let authService = AuthService() // or inject if you prefer
                        return authService.refreshTokens()
                            .flatMap { newLoginResponse -> AnyPublisher<T, APIError> in
                                // 4. If refresh was successful, save the new tokens
                                SessionManager.shared.saveLoginData(newLoginResponse)
                                // 5. Retry the original request with new token
                                return self.performRequest(endpoint, method: method, body: body, headers: headers)
                            }
                            .eraseToAnyPublisher()
                        
                    } else {
                        // Error is not 401, just propagate it
                        return Fail(error: error).eraseToAnyPublisher()
                    }
                }
                
                // End of pipeline
                .eraseToAnyPublisher()
        }
}
