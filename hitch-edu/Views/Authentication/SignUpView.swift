//
//  SignUpView.swift
//  hitch-edu
//
//  Created by Godson Umoren on 11/19/24.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var email: String
    
    @StateObject private var viewModel: AuthenticationViewModel
    
    enum Field {
        case firstName, lastName, birthDate, email, password
    }
    
    @FocusState private var infocus: Field?
    
    init(email: Binding<String>, authService: AuthService, navigationManager: NavigationManager) {
        _viewModel = StateObject(wrappedValue: AuthenticationViewModel(authService: authService, navigationManager: navigationManager))
        self._email = email
    }
    
    // State
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    
    @State private var birthDate: Date?
    
    @State private var password: String = ""
    
    @State private var placeholder: String = "Birthday (mm/dd/yyyy)"
    
    private var isValid: Bool {
        ![
            !firstName.isEmpty,
            !lastName.isEmpty,
            birthDate != nil,
            !password.isEmpty,
            password.count >= 8,
            password.range(of: "[A-Z]", options: .regularExpression) != nil,
            password.range(of: "[a-z]", options: .regularExpression) != nil,
            password.range(of: "\\d", options: .regularExpression) != nil,
            password.range(of: "[^A-Za-z\\d]", options: .regularExpression) != nil
        ].contains(false)
    }
    
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 40) {
                    Spacer().frame(height: 1)
                    
                    // Name
                    VStack(alignment: .leading, spacing: 10) {
                        VStack {
                            VStack(spacing: 0) {
                                TextField("First Name", text: $firstName)
                                    .padding()
                                    .background(
                                        RoundedCorners(radius: 10, corners: [.topLeft, .topRight])
                                            .stroke(Color.border, lineWidth: 0.5)
                                    )
                                    .textContentType(.givenName)
                                    .focused($infocus, equals: .firstName)
                                    .submitLabel(.next)
                                    .onSubmit {
                                        infocus = .lastName
                                    }
                                
                                TextField("Last Name", text: $lastName)
                                    .padding()
                                    .background(
                                        RoundedCorners(radius: 10, corners: [.bottomLeft, .bottomRight])
                                            .stroke(Color.border, lineWidth: 0.5)
                                    )
                                    .textContentType(.familyName)
                                    .focused($infocus, equals: .lastName)
                                    .submitLabel(.next)
                                    .onSubmit {
                                        infocus = .birthDate
                                    }
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.border, lineWidth: 0.5)
                            )
                        }
                        Text("Make sure it matches the name on your government ID")
                            .font(.geistMonoRegular(size: 12))
                            .foregroundColor(.secondary)
                    }
                    
                    // Date of Birth
                    VStack(alignment: .leading, spacing: 10) {
                        DatePickerTextField(date: $birthDate,
                                            placeholder: "Birthday (mm/dd/yyyy)",
                                            dateFormatter: dateFormatter
                        )
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(style: StrokeStyle(lineWidth: 0.5))
                        )
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($infocus, equals: .birthDate)
                        .submitLabel(.next)
                        .onSubmit {
                            infocus = .email
                        }
                        
                        Text("To sign up, you must be old enough to have a license in your state. Your birthday won't be shared with other people who use CarShareU.")
                            .font(.geistMonoRegular(size: 12))
                            .foregroundColor(.secondary)
                    }
                    
                    // Email
                    VStack(alignment: .leading, spacing: 10) {
                        VStack {
                            TextField("Email", text: $email)
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                                .textContentType(.emailAddress)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(style: StrokeStyle(lineWidth: 0.5))
                                )
                                .focused($infocus, equals: .email)
                                .submitLabel(.next)
                                .onSubmit {
                                    infocus = .password
                                }
                        }
                        Text("We will email you trip confirmation, reminders, and other important information.")
                            .font(.geistMonoRegular(size: 12))
                            .foregroundColor(.secondary)
                    }
                    
                    // Password
                    VStack(alignment: .leading, spacing: 10) {
                        SecureField("Password", text: $password)
                            .focused($infocus, equals: .password)
                            .padding()
                            .textContentType(.password)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(style: StrokeStyle(lineWidth: 0.5))
                            )
                            .submitLabel(.done)
                            .onSubmit {
                                // Final action when "Done" is pressed
                            }
                        
                        
                        PasswordValidatorView(password: $password)
                    }
                    
                    // Auth Button
                    LoadingButton(title: "Continue", action: {
                        viewModel.signup(firstname: firstName, lastname: lastName, dob: birthDate, email: email, password: password)
                    }, loading: viewModel.isLoading, buttonDisabled: !isValid)
                    .padding(.horizontal)
                }
                .padding()
                
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
                    Text("Finish signing up")
                        .font(.geistMonoMedium(size: 15))
                        .foregroundColor(Color.appTextPrimary)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var email = "user2@example.com"
    SignUpView(
        email: $email,
        authService: AuthService(),
        navigationManager: NavigationManager()
    )
}
