//
//  LoginView.swift
//  hitch-edu
//
//  Created by Godson Umoren on 11/19/24.
//

import SwiftUI

struct AuthenticationView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var navigationManager: NavigationManager
    
    @StateObject private var viewModel: AuthenticationViewModel
    
    @State private var email: String = ""
    @State private var navigateToLogin: Bool = false
    @State private var navigateToSignUp: Bool = false
    
    init(authService: AuthService, navigationManager: NavigationManager) {
        _viewModel = StateObject(wrappedValue: AuthenticationViewModel(authService: authService, navigationManager: navigationManager))
    }
    
    private var isEmailValid: Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    private var buttonDisabled: Bool {
        email.isEmpty || !isEmailValid
    }
    

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 40) {
                    Spacer()
                        .frame(height: 1)
                    
                    
                    // Email Input
                    VStack(alignment: .leading) {
                        Text("Enter Your Email")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        TextField("Email", text: $email)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.border, lineWidth: 1)
                            )
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                    }
                    .padding(.horizontal)
                    
                    // Continue Button with Loading Spinner
                    LoadingButton(
                        title: "Continue",
                        action: {
                            print("Checking Email")
                            viewModel.checkEmail(email: email)
                        },
                        loading: viewModel.isLoading,
                        buttonDisabled: buttonDisabled
                    )
                    .padding(.horizontal)
                    
                    
                    HStack(spacing: 10) {
                        VStack {
                            Divider()
                        }
                        Text("or")
                        VStack {
                            Divider()
                        }
                    }.frame(maxWidth: .infinity)
                    
                    // Error Message
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.appError)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    VStack(alignment: .center, spacing: 20) {
                        
                        // Apple Login
                        IconButton(
                            action: {
                                // TODO: Add Apple button action
                                print("Apple Login")
                            },
                            label: "Continue with Apple",
                            icon: .system(name: "applelogo")
                        )
                        
                        // Google Login
                        IconButton(
                            action: {
                                // TODO: Add Google button action
                                print("Google Login")
                            },
                            label: "Continue with Google",
                            icon: .custom(imageName: colorScheme == .dark ? "google-dark" : "google-light")
                        )
                    }
                    
                }
                .background(Color.clear)
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
            .onChange(of: viewModel.isEmailRegistered) { isRegistered in
                if let isRegistered = isRegistered {
                    if isRegistered {
                        navigateToLogin = true
                    } else {
                        navigateToSignUp = true
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginView(
                    email: $email,
                    authService: AuthService(),
                    navigationManager: viewModel.navigationManager
                )
            }
            .navigationDestination(isPresented: $navigateToSignUp) {
                SignUpView(  email: $email,
                             authService: AuthService(),
                             navigationManager: viewModel.navigationManager
                )
            }
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    if (!SessionManager.shared.isOnboardCompleted && SessionManager.shared.currentUser != nil) {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.backward")
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Login or sign up")
                            .font(.geistMonoMedium(size: 15))
                            .foregroundColor(Color.appTextPrimary)
                    }
                }
            }
        }
       
    }
}

#Preview {
    AuthenticationView(authService: AuthService(), navigationManager: NavigationManager())
        .environmentObject(NavigationManager())
}
