//
//  AuthenticationViewModel.swift
//  hitch-edu
//
//  Created by Godson Umoren on 11/20/24.
//

import Foundation
import Combine
import SwiftUI

class AuthenticationViewModel: ObservableObject {
    let authService: AuthService
    let navigationManager: NavigationManager
    @Published var isEmailRegistered: Bool? = nil
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var loginResponse: LoginResponse? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    init(authService: AuthService, navigationManager: NavigationManager) {
        self.authService = authService
        self.navigationManager = navigationManager
    }
    
    
    // Check if email exists in the database
    func checkEmail(email: String) {
        isLoading = true // Start loading
        authService.check_email(email: email)
            .receive(on: DispatchQueue.main) // Ensure updates happen on the main thread
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.isLoading = false // Stop loading after delay
                    self.errorMessage = "Failed to check email: \(error.localizedDescription)"
                    print("Error: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { response in
                
                
                // Simulate delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.isLoading = false // Stop loading after the delay
                    self.isEmailRegistered = response.registered
                    print("Email registered: \(response.registered)")
                }
            })
            .store(in: &self.cancellables)
    }
    
    // Log in user
    func login(email: String, password: String) {
        isLoading = true // Start loading
        

        
        authService.login(email: email, password: password)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.isLoading = false
                    self.errorMessage = "Login failed: \(error.localizedDescription)"
                case .finished:
                    break
                }
            }, receiveValue: { response in
                SessionManager.shared.saveLoginData(response)
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.navigationManager.navigateToHome = true
                    
                    self.navigationManager.navigateToAuthentication = false
                }
            })
            .store(in: &cancellables)
    }
    
    // Sign Up
    func signup(firstname: String, lastname: String, dob:Date?, email: String, password: String) {
        isLoading = true
        self.navigationManager.navigateToHome = false
        
        authService.signup(firstname: firstname, lastname: lastname, dob: dob, email: email, password: password)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.isLoading = false
                    self.errorMessage = "Signup failed: \(error.localizedDescription)"
                case .finished:
                    break
                }
            }, receiveValue: { response in
                SessionManager.shared.saveLoginData(response)
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.navigationManager.navigateToHome = true
                }
            })
            .store(in: &cancellables)
        
    }
    
    func requestCode(email: String, onNavigateToVerify: @escaping () -> Void) {
        isLoading = true
        
        authService.requestCode(email: email)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.isLoading = false
                    self.errorMessage = "Request Code Failed: \(error.localizedDescription)"
                case .finished:
                    break
                }
            }, receiveValue: { response in
                DispatchQueue.main.async {
                    self.isLoading = false
                    onNavigateToVerify()
                }
            })
            .store(in: &cancellables)
    }

    // Verify Code
    func verfyCode(email: String, code: String, onCodeVerified: @escaping () -> Void) {
        isLoading = true // Start loading
        
        authService.verfyCode(email: email, code: code)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.isLoading = false
                    self.errorMessage = "Verification failed: \(error.localizedDescription)"
                case .finished:
                    break
                }
            }, receiveValue: { response in
                if response.valid {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        onCodeVerified()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.errorMessage = "Invalid verification code."
                    }
                }
            })
            .store(in: &cancellables)
    }

    // Reset Password
    func resetPassword(email: String, password: String, confirmPassword: String, onDone: @escaping () -> Void) {
        isLoading = true // Start loading
        
        authService.resetPassword(email: email, password: password, confirmPassword: confirmPassword)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.isLoading = false
                    self.errorMessage = "Password reset failed: \(error.localizedDescription)"
                case .finished:
                    break
                }
            }, receiveValue: { response in
                if response.reset {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        onDone()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.errorMessage = "Failed to reset password."
                    }
                }
            })
            .store(in: &cancellables)
    }

}
