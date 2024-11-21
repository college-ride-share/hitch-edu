//
//  Login.swift
//  hitch-edu
//
//  Created by Godson Umoren on 11/20/24.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var email: String
    
    @StateObject private var viewModel: AuthenticationViewModel
    
    @State private var password: String = ""
    @State private var navigateToForgotPassword: Bool = false
    
    init(email: Binding<String>, authService: AuthService, navigationManager: NavigationManager) {
        _viewModel = StateObject(wrappedValue: AuthenticationViewModel(authService: authService, navigationManager: navigationManager))
        self._email = email
    }
    
    private var buttonDisabled: Bool {
        email.isEmpty || password.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 40) {
                    Spacer().frame(height: 1)
                    
                    // Header
                    VStack(alignment:.center, spacing: 20) {
                        Image(systemName: "car")
                            .resizable()
                            .scaledToFit()
                            .containerRelativeFrame(.horizontal) { size, axis in
                                    size * 0.15
                            }
                        
                        Text("Welcome Back!")
                            .font(.geistSemiBold(size: 30))
                    }
                    
                    // Password Input
                    VStack(alignment: .leading) {
                        Text("Enter Your Password")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        SecureField("Passowrd", text: $password)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.border, lineWidth: 1)
                            )
                            .textContentType(.newPassword)
                    }
                    .padding(.horizontal)
                    
                    // Authentication Button
                    LoadingButton(title: "Continue", action: {
                        viewModel.login(email: email, password: password)
                        
                    }, loading: viewModel.isLoading, buttonDisabled: buttonDisabled).padding(.horizontal)
                    
                    Button(action: {
                        print("Forgot Password Tapped")
                        
                        // Set Navigate to Forgot Password Screen to true
                        navigateToForgotPassword.toggle()
                    }) {
                        Text("Forgot Password")
                            .font(.geistRegular(size: 15))
                            .underline()
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if !(SessionManager.shared.isOnboardCompleted && SessionManager.shared.currentUser != nil) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.gray)
                    }
                }
            }
            
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Log in")
                        .font(.geistMonoMedium(size: 15))
                        .foregroundColor(Color.appTextPrimary)
                }
            }
        }
        .navigationDestination(isPresented: $navigateToForgotPassword) {
                   ForgotPassowrdView(
                       email: $email,
                       authService: viewModel.authService,
                       navigationManager: viewModel.navigationManager
                   )
               }
    }
}

#Preview {
    @Previewable @State var email = "user@example.com"
    LoginView(
        email: $email,
        authService: AuthService(),
        navigationManager: NavigationManager()
    )
}
