//
//  ProfileView.swift
//  hitch-edu
//
//  Created by Godson Umoren on 1/11/25.
//

import SwiftUI

struct ProfileView: View {
    // Directly fetch the current user (if any) from our SessionManager
    private var user: User? {
        return SessionManager.shared.currentUser
    }

    var body: some View {
        VStack(spacing: 16) {
            if let user = user {
                // Display user details
                Text("User ID: \(user.id)")
                Text("Email: \(user.email)")
                Text("First Name: \(user.firstname)")
                Text("Last Name: \(user.lastname)")
                Text("DOB: \(user.dob)")
                Text("Is Driver: \(user.isDriver ? "Yes" : "No")")
            } else {
                // If there is no currentUser, prompt user to log in
                Text("No user is logged in. Please log in.")
            }
        }
        .padding()
    }
}

#Preview {
    ProfileView()
}
