//
//  AuthService.swift
//  hitch-edu
//
//  Created by Godson Umoren on 11/20/24.
//

import Foundation
import Combine

class AuthService: APIService {
    private let baseURL = Constants.API.baseURL + "/auth"
    
    // Email Check
    func check_email(email: String) -> AnyPublisher<CheckEmailResponse, APIError> {
        let endpoint = "\(baseURL)/check-email"
        let requestBody = [
            "email": email,
        ]
        
        guard let bodyData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        return performRequest(endpoint, method: .POST, body: bodyData)
            .handleEvents(receiveSubscription: { _ in
                print("Starting request to \(endpoint)")
            }, receiveOutput: { response in
                print("Received response: \(response)")
            }, receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Request failed with error: \(error)")
                }
            })
            .eraseToAnyPublisher()
    }
    
    // User Log In
//    func login(email: String, password: String) -> AnyPublisher<LoginResponse, APIError> {
//        let endpoint = "\(baseURL)/login"
//        let requestBody = [
//            "email": email,
//            "password": password,
//        ]
//        
//        guard let bodyData = try? JSONSerialization.data(withJSONObject: requestBody) else {
//            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
//        }
//        
//        return performRequest(endpoint, method: .POST, body: bodyData)
//            .handleEvents(receiveSubscription: { _ in
//                print("Starting request to \(endpoint)")
//            }, receiveOutput: { response in
//                print("Received response: \(response)")
//            }, receiveCompletion: { completion in
//                if case let .failure(error) = completion {
//                    print("Request failed with error: \(error)")
//                }
//            })
//            .eraseToAnyPublisher()
//    }
    
    // User Login
    func login(email: String, password: String) -> AnyPublisher<LoginResponse, APIError> {
        let endpoint = "\(baseURL)/login"
        let requestBody = [
            "email": email,
            "password": password,
        ]
        
        guard let bodyData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        return performRequest(endpoint, method: .POST, body: bodyData)
            .handleEvents(receiveSubscription: { _ in
                print("Starting login request to \(endpoint)")
            }, receiveOutput: { response in
                print("Login response received: \(response)")
            }, receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Login failed with error: \(error)")
                }
            })
            .eraseToAnyPublisher()
    }
}


// Response model for user login
struct LoginResponse: Decodable {
    let access_token: String
    let refresh_token: String
    let token_type: String
    let user: UserResponse
}

// Response model for user details
struct UserResponse: Codable {
    let id: String
    let email: String
    let name: String
    let is_driver: Bool
}

// Response Model for email check
struct CheckEmailResponse: Decodable {
    let registered: Bool;
}
