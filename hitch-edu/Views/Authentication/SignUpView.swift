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

    var body: some View {
        NavigationStack {
            Text("Sign Up!")
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
    SignUpView(email: $email)
}
