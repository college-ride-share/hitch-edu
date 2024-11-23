//
//  PasswordValidator.swift
//  hitch-edu
//
//  Created by Godson Umoren on 11/21/24.
//

import SwiftUI

struct PasswordValidatorView: View {
    @Binding var password: String

    var isHidden: Bool {
        let allValid = [
            password.count >= 8,
            password.range(of: "[A-Z]", options: .regularExpression) != nil,
            password.range(of: "[a-z]", options: .regularExpression) != nil,
            password.range(of: "\\d", options: .regularExpression) != nil,
            password.range(of: "[^A-Za-z\\d]", options: .regularExpression) != nil
        ].allSatisfy { $0 }
        return password.isEmpty || allValid
    }

    var body: some View {
        if !isHidden {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .center, spacing: 5) {
                    Image(systemName: "info.circle")
                        .foregroundColor(passwordStrengthColor)
//                        .frame(width: 20, height: 20)
                    
                    Text("Password strength: \(passwordStrength)")
                        .foregroundColor(passwordStrengthColor)
                        .font(.geistMonoSemiBold(size: 10))
                }

                RequirementView(requirement: "At least 8 characters",
                                isMet: password.count >= 8)
                RequirementView(requirement: "At least one uppercase letter",
                                isMet: password.range(of: "[A-Z]", options: .regularExpression) != nil)
                RequirementView(requirement: "At least one lowercase letter",
                                isMet: password.range(of: "[a-z]", options: .regularExpression) != nil)
                RequirementView(requirement: "At least one number",
                                isMet: password.range(of: "\\d", options: .regularExpression) != nil)
                RequirementView(requirement: "At least one special character",
                                isMet: password.range(of: "[^A-Za-z\\d]", options: .regularExpression) != nil)
            }
            .transition(.opacity) // Smoothly fades in/out
        }
    }

    private var passwordStrength: String {
        let strength = [
            password.count >= 8,
            password.range(of: "[A-Z]", options: .regularExpression) != nil,
            password.range(of: "[a-z]", options: .regularExpression) != nil,
            password.range(of: "\\d", options: .regularExpression) != nil,
            password.range(of: "[^A-Za-z\\d]", options: .regularExpression) != nil
        ].filter { $0 }.count

        switch strength {
        case 0...2: return "Weak"
        case 3...4: return "Moderate"
        case 5: return "Strong"
        default: return "Weak"
        }
    }

    private var passwordStrengthColor: Color {
        switch passwordStrength {
        case "Weak": return .red
        case "Moderate": return .orange
        case "Strong": return .green
        default: return .red
        }
    }
}

struct RequirementView: View {
    let requirement: String
    let isMet: Bool

    var body: some View {
        HStack {
            Image(systemName: isMet ? "checkmark" : "xmark")
//                .frame(width: 10, height: 10)
                .foregroundColor(isMet ? .green : .red)
            Text(requirement)
                .foregroundColor(.primary)
                .font(.geistMonoMedium(size: 10))
        }
    }
}

#Preview() {
    @Previewable @State var password: String = "mew"
    PasswordValidatorView(password: $password)
}
