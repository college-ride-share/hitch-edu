//
//  LoginView.swift
//  hitch-edu
//
//  Created by Godson Umoren on 11/19/24.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        
        Text("Login")
            .font(.geistExtraBold(size: 18))
        
        //            .navigationTitle("Log in or sign up")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 20, height: 20) // << for demo
                            .foregroundColor(.gray)
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

#Preview {
    LoginView()
}
