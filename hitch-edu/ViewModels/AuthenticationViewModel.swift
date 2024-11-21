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
                }
            })
            .store(in: &cancellables)
    }
}
