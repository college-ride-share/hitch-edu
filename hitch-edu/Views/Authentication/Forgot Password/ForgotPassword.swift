//
//  ForgotPassowrdView.swift
//  hitch-edu
//
//  Created by Godson Umoren on 11/19/24.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel: AuthenticationViewModel
    @Binding var email: String
    
    init(email: Binding<String>, authService: AuthService, navigationManager: NavigationManager) {
        _viewModel = StateObject(wrappedValue: AuthenticationViewModel(authService: authService, navigationManager: navigationManager))
        self._email = email
    }
    
    
    private var buttonDisabled: Bool {
        email.isEmpty
    }
    
    @State private var navigateToVerify: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing:40) {
                    Spacer().frame(height: 1)
                    
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
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(
                            errorMessage == "Request Code Failed: Server error with status code: 400" ?
                            "We couldn’t process your request. Please check the email address you entered and try again." :
                            errorMessage
                        )
                        .foregroundColor(.appError)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    }
                    
                    // Authentication Button
                    LoadingButton(title: "Continue", action: {
                        viewModel.requestCode(email: email, onNavigateToVerify: {
                            navigateToVerify = true
                        })
                    }, loading: viewModel.isLoading, buttonDisabled: buttonDisabled).padding(.horizontal)
                }
            }
        }
        .background(Color.clear)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
               
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.gray)
                    }
                }
            
            
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Forgot Password")
                        .font(.geistMonoMedium(size: 15))
                        .foregroundColor(Color.appTextPrimary)
                }
            }
        }
        .navigationDestination(isPresented: $navigateToVerify) {
            VerifyCodeView(email: $email, authService: viewModel.authService, navigationManager: viewModel.navigationManager)
        }
    }
}

#Preview {
    @Previewable @State var email: String = ""
    ForgotPasswordView(
        email: $email,
        authService: AuthService(),
        navigationManager: NavigationManager()
    )
}
