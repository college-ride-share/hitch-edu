//
//  NewPasswordView.swift
//  hitch-edu
//
//  Created by Godson Umoren on 11/23/24.
//

import SwiftUI

struct NewPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel: AuthenticationViewModel
    @Binding var email: String
    
    init(email: Binding<String>, authService: AuthService, navigationManager: NavigationManager) {
        _viewModel = StateObject(wrappedValue: AuthenticationViewModel(authService: authService, navigationManager: navigationManager))
        self._email = email
    }
    
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    @FocusState private var infocus: Field?
    enum Field {
        case password, confirmPassword
    }
    
    @State private var navigateToLogin: Bool = false
    
    private var isValid: Bool {
        ![
            password.count >= 8,
            password.range(of: "[A-Z]", options: .regularExpression) != nil,
            password.range(of: "[a-z]", options: .regularExpression) != nil,
            password.range(of: "\\d", options: .regularExpression) != nil,
            password.range(of: "[^A-Za-z\\d]", options: .regularExpression) != nil,
            
            confirmPassword.count >= 8,
            confirmPassword.range(of: "[A-Z]", options: .regularExpression) != nil,
            confirmPassword.range(of: "[a-z]", options: .regularExpression) != nil,
            confirmPassword.range(of: "\\d", options: .regularExpression) != nil,
            confirmPassword.range(of: "[^A-Za-z\\d]", options: .regularExpression) != nil,
            
            confirmPassword == password
        ].contains(false)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing:40) {
                    Spacer().frame(height: 1)
                    
                    // Header
                    VStack(alignment:.center, spacing: 20) {
                        Image(systemName: "lock")
                            .resizable()
                            .scaledToFit()
                            .containerRelativeFrame(.horizontal) { size, axis in
                                    size * 0.15
                            }
                        
                        Text("Reset Password")
                            .font(.geistSemiBold(size: 30))
                    }
                    
                    // Password
                    VStack(alignment: .leading, spacing: 10) {
                        VStack {
                            VStack(spacing: 0) {
                                SecureField("New Password", text:$password)
                                    .padding()
                                    .background(
                                        RoundedCorners(radius: 10, corners: [.topLeft, .topRight])
                                            .stroke(Color.border, lineWidth: 0.5)
                                    )
                                    .textContentType(.newPassword)
                                    .focused($infocus, equals: .password)
                                    .submitLabel(.next)
                                    .onSubmit {
                                        infocus = .confirmPassword
                                    }
                                
                                PasswordValidatorView(password: $password)
                                
                                SecureField("Confirm Password", text: $confirmPassword)
                                    .padding()
                                    .background(
                                        RoundedCorners(radius: 10, corners: [.bottomLeft, .bottomRight])
                                            .stroke(Color.border, lineWidth: 0.5)
                                    )
                                    .textContentType(.newPassword)
                                    .focused($infocus, equals: .confirmPassword)
                                    .submitLabel(.done)
                                    .onSubmit {
                                       
                                    }
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.border, lineWidth: 0.5)
                            )
                        }
                        Text("Passwords must match")
                            .font(.geistMonoRegular(size: 12))
                            .foregroundColor((confirmPassword == password) ? .secondary : .error)
                        
                        PasswordValidatorView(password: $confirmPassword)
                    }
                    
                    // Auth Button
                    LoadingButton(title: "Continue", action: {
                        viewModel.resetPassword(email: email, password: password, confirmPassword: confirmPassword, onDone: {
                            navigateToLogin.toggle()
                        })
                    }, loading: viewModel.isLoading, buttonDisabled: !isValid)
                    .padding(.horizontal)
                }
                .padding( )
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
                    Text("Create New Password")
                        .font(.geistMonoMedium(size: 15))
                        .foregroundColor(Color.appTextPrimary)
                }
            }
        }
        .navigationDestination(isPresented: $navigateToLogin) {
            LoginView(
                email: $email, authService: AuthService(), navigationManager: viewModel.navigationManager
            )
                .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    @Previewable @State var email: String = ""
    NewPasswordView(
        email: $email,
        authService: AuthService(),
        navigationManager: NavigationManager()
    )
}
