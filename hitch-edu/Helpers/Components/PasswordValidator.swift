//
//  PasswordValidator.swift
//  hitch-edu
//
//  Created by Godson Umoren on 11/21/24.
//

import SwiftUI

struct PasswordValidator: View {
    @Binding var password: String
    @State private var validationMessages: [ValidationMessage] = []
    
    var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                
                Text("Password strength: \(isPasswordStrong() ? "strong" : "weak")")
                    .font(.headline)
                    .foregroundColor(isPasswordStrong() ? .green : .red)
                    .padding(.top, 5)

                ForEach(validationMessages) { message in
                    HStack {
                        Image(systemName: message.isValid ? "checkmark.circle" : "xmark.circle")
                            .foregroundColor(message.isValid ? .green : .red)
                        Text(message.message)
                            .foregroundColor(message.isValid ? .green : .red)
                    }
                }

                Spacer()
            }
            .padding()
        }

        func validatePassword(_ password: String) {
            validationMessages = [
                ValidationMessage(message: "Must be at least 8 characters", isValid: password.count >= 8),
                ValidationMessage(message: "Must have at least one uppercase letter", isValid: password.range(of: "[A-Z]", options: .regularExpression) != nil),
                ValidationMessage(message: "Must have at least one lowercase letter", isValid: password.range(of: "[a-z]", options: .regularExpression) != nil),
                ValidationMessage(message: "Must have at least one number", isValid: password.range(of: "[0-9]", options: .regularExpression) != nil),
                ValidationMessage(message: "Must have at least one special character", isValid: password.range(of: "[!@#$%^&*(),.?\":{}|<>]", options: .regularExpression) != nil)
            ]
        }

        func isPasswordStrong() -> Bool {
            return validationMessages.allSatisfy { $0.isValid }
        }
    }

    struct ValidationMessage: Identifiable {
        let id = UUID()
        let message: String
        let isValid: Bool
    }

#Preview {
    @Previewable @State var password: String = ""
    PasswordValidator(password: $password)
}
