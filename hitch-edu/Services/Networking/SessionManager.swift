//
//  SessionManager.swift
//  hitch-edu
//
//  Created by Godson Umoren on 11/20/24.
//

import Foundation
import SwiftUI
import Combine

class SessionManager {
    static let shared = SessionManager()

    private let baseURL = Constants.API.baseURL
    private let refreshEndpoint = "/auth/refresh"
    private let tokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"
    private let userKey = "currentUser"
    private let onboardKey = "onBoardCompleted"

    private var isRefreshing = false
    private var refreshSubject: PassthroughSubject<LoginResponse, APIError>?
    private var refreshQueue = [(Result<String, Error>) -> Void]()
    
    private var cancellables = Set<AnyCancellable>()

    

    // Function to check if user has completed on-boarding process
    var isOnboardCompleted: Bool {
        get {
            guard let onboardStatus = KeychainHelper.shared.retrieve(for: onboardKey) else {
                return false
            }
            return onboardStatus == "true"
        }
        set {
            KeychainHelper.shared.save(newValue ? "true" : "false", for: onboardKey)
        }
    }
    

    var currentUser: User? {
        get {
            if let data = UserDefaults.standard.data(forKey: userKey) {
//                print("Fetching user from UserDefaults...")
                if let user = try? JSONDecoder().decode(User.self, from: data) {
//                    print("User successfully fetched: \(user)")
                    return user
                } else {
                    print("Failed to decode user.")
                }
            }
            return nil
        }
        set {
            if let user = newValue {
                print("Saving user to UserDefaults: \(user)")
                if let data = try? JSONEncoder().encode(user) {
                    UserDefaults.standard.set(data, forKey: userKey)
                } else {
                    print("Failed to encode user.")
                }
            } else {
                print("Clearing current user.")
                UserDefaults.standard.removeObject(forKey: userKey)
            }
        }
    }

    func isTokenValid() -> Bool {
        guard let token = KeychainHelper.shared.retrieve(for: tokenKey) else {
            print("Token not found in Keychain.")
            return false
        }
        let parts = token.split(separator: ".")
        guard parts.count == 3 else {
            print("Invalid token structure.")
            return false
        }

        // Decode the payload
        var payloadBase64 = String(parts[1])
        
        // Add padding if necessary
        while payloadBase64.count % 4 != 0 {
            payloadBase64 += "="
        }
        
        if let payloadData = Data(base64Encoded: payloadBase64, options: .ignoreUnknownCharacters),
           let payload = try? JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any] {
            
            if let exp = payload["exp"] as? TimeInterval {
                let expiryDate = Date(timeIntervalSince1970: exp)
                let isValid = expiryDate > Date()
                if !isValid {
                    print("Token expired. Expiry Date: \(expiryDate)")
                }
                return isValid
            } else {
                print("No 'exp' field found in token payload.")
            }
        } else {
            print("Failed to decode the payload.")
        }

        return false
    }
    
    func saveLoginData(_ loginResponse: LoginResponse) {
        print("Saving login data to SessionManager")
        
        // Save access and refresh tokens securely
        KeychainHelper.shared.save(loginResponse.access_token, for: tokenKey)
        KeychainHelper.shared.save(loginResponse.refresh_token, for: refreshTokenKey)

        // Save user details to UserDefaults
        if let userData = try? JSONEncoder().encode(loginResponse.user) {
            UserDefaults.standard.set(userData, forKey: userKey)
        } else {
            print("Failed to encode and save user data.")
        }

        // Set onboarding status
        if !isOnboardCompleted {
            KeychainHelper.shared.save("true", for: onboardKey)
            print("Onboarding status saved to Keychain.")
        }

        // Set current user
        currentUser = User(from: loginResponse.user)
        print("Current user set: \(String(describing: currentUser))")
    }
    
    // MARK: - Token Refresh with Simultaneous Expiry Handling
        /// Refresh the tokens if they are expired or if a 401 occurred.
        /// This ensures only ONE refresh request goes out at a time.
        func refreshTokens() -> AnyPublisher<LoginResponse, APIError> {
            // If we're already in the middle of refreshing, just return the existing publisher
            if isRefreshing, let existingSubject = refreshSubject {
                return existingSubject.eraseToAnyPublisher()
            }
            
            // Otherwise, create a new subject and mark that we are refreshing
            let subject = PassthroughSubject<LoginResponse, APIError>()
            refreshSubject = subject
            isRefreshing = true

            // Call into AuthService to actually perform the refresh
            let authService = AuthService()
            authService.refreshTokens()
                .sink { [weak self] completion in
                    guard let self = self else { return }
                    switch completion {
                    case .finished:
                        // Once finished, complete the subject
                        subject.send(completion: .finished)
                    case .failure(let error):
                        // If refresh fails, propagate the error
                        subject.send(completion: .failure(error))
                    }
                    // Reset flags/subject
                    self.isRefreshing = false
                    self.refreshSubject = nil
                } receiveValue: { [weak self] loginResponse in
                    guard let self = self else { return }
                    // Save the newly refreshed tokens in SessionManager
                    self.saveLoginData(loginResponse)
                    // Send the response to all subscribers
                    subject.send(loginResponse)
                }
                .store(in: &cancellables)

            return subject.eraseToAnyPublisher()
        }
    

    func clearSession() {
        KeychainHelper.shared.delete(for: tokenKey)
        KeychainHelper.shared.delete(for: refreshTokenKey)
        UserDefaults.standard.removeObject(forKey: userKey)
        KeychainHelper.shared.delete(for: onboardKey)
    }

    func logout() {
        KeychainHelper.shared.delete(for: tokenKey)
        KeychainHelper.shared.delete(for: refreshTokenKey)
        currentUser = nil
    }
}
