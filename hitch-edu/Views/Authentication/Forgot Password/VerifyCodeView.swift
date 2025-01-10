//
//  VerifyCodeView.swift
//  hitch-edu
//
//  Created by Godson Umoren on 11/23/24.
//

import SwiftUI

struct VerifyCodeView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel: AuthenticationViewModel
    @Binding var email: String
    
    init(email: Binding<String>, authService: AuthService, navigationManager: NavigationManager) {
        _viewModel = StateObject(wrappedValue: AuthenticationViewModel(authService: authService, navigationManager: navigationManager))
        self._email = email
    }
    
    @State private var code: String = ""
    @State private var navigateToCreatePassword: Bool = false
    
    private var buttonDisabled: Bool {
        code.isEmpty
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
                    
                    // Code Entry
                    VStack(alignment: .leading) {
                        Text("Verfication Code")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        TextField("Code", text: $code)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.border, lineWidth: 1)
                            )
                            .autocapitalization(.none)
                            .textContentType(.oneTimeCode)
                        
                        Text("Enter the code sent to your email.")
                            .font(.geistMonoRegular(size: 12))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(
                            errorMessage == "Verification failed: Server error with status code: 422" ?
                            "We couldn’t process your request. Please check the code you entered and try again." :
                            errorMessage
                        )
                        .foregroundColor(.appError)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    }
                    
                    // Authentication Button
                    LoadingButton(title: "Continue", action: {
                        viewModel.verfyCode(email: email, code: code, onCodeVerified: {
                            navigateToCreatePassword = true
                        })
                    }, loading: viewModel.isLoading, buttonDisabled: buttonDisabled).padding(.horizontal)
                }
                .padding( )

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
                    Text("Verify Code")
                        .font(.geistMonoMedium(size: 15))
                        .foregroundColor(Color.appTextPrimary)
                }
            }
        }
        .navigationDestination(isPresented: $navigateToCreatePassword) {
            NewPasswordView(
                email: $email,
//                code: $code,
                authService: viewModel.authService,
                navigationManager: viewModel.navigationManager
            )
        }
    }
}

#Preview {
    @Previewable @State var email: String = ""
   
    VerifyCodeView(
        email: $email,
        authService: AuthService(),
        navigationManager: NavigationManager()
    )
}
