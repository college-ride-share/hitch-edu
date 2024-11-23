//
//  ForgotPassowrdView.swift
//  hitch-edu
//
//  Created by Godson Umoren on 11/19/24.
//

import SwiftUI

struct ForgotPassowrdView: View {
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
                    
                    // Authentication Button
                    LoadingButton(title: "Continue", action: {
                        print("Forgot Password Tapped")
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
                    Text("Forgot Password")
                        .font(.geistMonoMedium(size: 15))
                        .foregroundColor(Color.appTextPrimary)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var email: String = ""
    ForgotPassowrdView(
        email: $email,
        authService: AuthService(),
        navigationManager: NavigationManager()
    )
}
