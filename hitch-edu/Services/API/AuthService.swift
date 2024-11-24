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
    
    // User Sign Up
    func signup(firstname: String, lastname: String, dob:Date?, email: String, password: String) -> AnyPublisher<LoginResponse, APIError> {
       
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        let endpoint = "\(baseURL)/signup"
        let requestBody = [
            "firstname": firstname,
            "lastname": lastname,
            "dob": formatter.string(from: dob!),
            "email": email,
            "password": password,
        ] as [String : Any]
        
        guard let bodyData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        return performRequest(endpoint, method: .POST, body: bodyData)
            .handleEvents(receiveSubscription: {_ in
                print("Starting signup request to \(endpoint)")
            }, receiveOutput: {
                response in print("Received signup response: \(response)")
            }, receiveCompletion: {
                completion in if case let .failure(error) = completion {
                    print("Error signing up: \(error)")
                }
            })
            .eraseToAnyPublisher()
    }
    
    // Request Code
    func requestCode(email: String) -> AnyPublisher<CodeRequestResponse, APIError> {
        let endpoint = "\(baseURL)/request-reset"
        let requestBody = ["email": email] as [String : Any]
        
        guard let bodyData = try? JSONSerialization.data(withJSONObject: requestBody, options: .prettyPrinted) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        return performRequest(endpoint, method: .POST, body: bodyData)
            .handleEvents(receiveSubscription: {_ in
                print("Starting code request to \(endpoint)")
            }, receiveOutput: {
                response in print("Received code response: \(response)")
            }, receiveCompletion: {
                completion in if case let .failure(error) = completion {
                    print("Error getting code: \(error)")
                }
            })
            .eraseToAnyPublisher()
    }
    
    // Verify Code
    func verfyCode(email: String, code: String) -> AnyPublisher<CodeVerifyResponse, APIError> {
        let endpoint = "\(baseURL)/verify-reset"
        let requestBody = ["email": email, "code": code] as [String : Any]
        
        guard let bodyData = try? JSONSerialization.data(withJSONObject: requestBody, options: .prettyPrinted) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        return performRequest(endpoint, method: .POST, body: bodyData)
            .handleEvents(receiveSubscription: {_ in
                print("Starting code verification to \(endpoint)")
            }, receiveOutput: {
                response in print("Received response: \(response)")
            }, receiveCompletion: {
                completion in if case let .failure(error) = completion {
                    print("Error verifying code: \(error)")
                }
            })
            .eraseToAnyPublisher()
    }
    
    // Reset Passoword
    func resetPassword(email: String, password: String, confirmPassword:String) -> AnyPublisher<ResetPasswordResponse, APIError> {
     let endpoint = "\(baseURL)/reset-password"
        let requestBody = ["email": email, "new_password": password, "confirm_password": confirmPassword] as [String : Any]
        
        guard let bodyData = try? JSONSerialization.data(withJSONObject: requestBody, options: .prettyPrinted) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        return performRequest(endpoint, method: .POST, body: bodyData)
            .handleEvents(receiveSubscription: {_ in
                print("Starting password reset to \(endpoint)")
            }, receiveOutput: {
                response in print("Received response: \(response)")
            }, receiveCompletion: {
                completion in if case let .failure(error) = completion {
                    print("Error resetting password: \(error)")
                }
            })
            .eraseToAnyPublisher()
    }
}


// Response model for user login
struct LoginResponse: Decodable {
    let access_token: String
    let token_type: String
    let refresh_token: String
    let user: UserResponse
}

// Response model for user details
struct UserResponse: Codable {
    let id: String
    let email: String
    let is_driver: Bool
    let firstname: String
    let lastname: String
    let dob: String
}

// Response Model for email check
struct CheckEmailResponse: Decodable {
    let registered: Bool;
}

// Response Model for request code
struct CodeRequestResponse: Decodable {
    let message: String
}

// Response Model for verify code
struct CodeVerifyResponse: Decodable {
    let valid: Bool
}

// Respose Model for forgot password
struct ResetPasswordResponse: Decodable {
    let reset: Bool
}
