//
//  ContentView.swift
//  hitch-edu
//
//  Created by Godson Umoren on 11/18/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isVisible = false // For animation
    @State private var navigateToOnBoarding = false // Navigation state
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground // Set the background color
                    .ignoresSafeArea()
                
                VStack {
                    Text("CarShareU")
                        .font(.geistExtraBold(size: 32))
                        .padding(15)
                        .background(Color.appPrimary)
                        .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                        .cornerRadius(15)
                        .opacity(isVisible ? 1 : 0) // Fade effect
                        .offset(y: isVisible ? 0 : 50) // Slide in from the bottom
                        .animation(.easeOut(duration: 1.0), value: isVisible) // Apply animation
                }
                .padding()
            }
            .onAppear {
                // Trigger the animation
                isVisible = true
                
                // Schedule navigation 10 seconds after animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    navigateToOnBoarding = true
                }
            }
            .navigationDestination(isPresented: $navigateToOnBoarding) {
                OnBoardingView() // Navigate to OnBoardingView
                    .navigationBarBackButtonHidden(true);
            }
        }
    }
}

#Preview {
    ContentView()
}
