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
    
    
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        
        // Start date: January 1, 1900
        let startComponents = DateComponents(year: 1900, month: 1, day: 1)
        guard let startDate = calendar.date(from: startComponents) else {
            fatalError("Invalid start date components")
        }
        
        // End date: Today's date
        let endDate = Date()
        
        return startDate...endDate
    }()
    
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 40){
                    Spacer().frame(height: 1)
                    
                    // Name
                    VStack(alignment: .leading, spacing: 10) {
                        VStack {
                            TextField("First Name", text: $firstName)
                                .padding()
                            
                            TextField("Last Name", text: $lastName)
                                .padding()
                            
                        }
                        Text("Make sure it matches the name on your government ID")
                            .font(.geistMonoRegular(size: 12))
                            .foregroundColor(.secondary)
                    }
                    
                    // Date of Birth
                    VStack {
                        DatePickerTextField(date: $birthDate,
                                            placeholder: "Birthday (mm/dd/yyyy)",
                                            dateFormatter: dateFormatter
                        )
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Text("To sign up, you must be old enough to have a license in your state. Your birthday won't be shared with other people who use CarShareApp.")
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
                            
                        }
                        Text("We will email you trip confirmation, reminders, and other important information.")
                            .font(.geistMonoRegular(size: 12))
                            .foregroundColor(.secondary)
                    }
                    
                    // Password
                    VStack {
                        SecureField("Passowrd", text: $password)
                            .padding()
                            .textContentType(.newPassword)
                        PasswordValidator(password: $password)
                    }
                    
                    // Auth Button
                    LoadingButton(title: "Continue", action: {
                        print("sign up")
                    }, loading: false, buttonDisabled: true)
                }
                .padding()
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
