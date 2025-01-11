//
//  AppView.swift
//  hitch-edu
//
//  Created by Godson Umoren on 1/11/25.
//

import SwiftUI

struct AppView: View {
    
    var body: some View {
        
        VStack {
            // Bottom Tab Navigator
            TabView {
                
                // Home
                Tab("Home", systemImage: "magnifyingglass") {
                    HomeView()
                }
                ///.badge(2)
                
                // Trips
                Tab("Trips", systemImage: "map.fill") {
                    TripsView()
                }
                
                // Messages
                Tab("Messages", systemImage: "message.fill") {
                    MessagesView()
                }
                
                
                // Profile
                Tab("Profile", systemImage: "person.crop.circle.fill") {
                    NavigationStack {
                        ProfileView()
                    }
                }
            }

            
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    AppView()
}
