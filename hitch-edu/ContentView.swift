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
    
//        init() {
//            SessionManager.shared.clearSession()
//        }
    
    
    @EnvironmentObject var navigationManager: NavigationManager // Injected NavigationManager
    
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
                    handleNavigation()
                }
            }
            .navigationDestination(isPresented: $navigationManager.navigateToOnBoarding) {
                OnBoardingView()
                    .navigationBarBackButtonHidden(true)
            }
            .sheet(isPresented: $navigationManager.navigateToAuthentication) {
                AuthenticationView(
                       authService: AuthService(),
                       navigationManager: navigationManager
                   )
                    .navigationBarBackButtonHidden(true)
                    .interactiveDismissDisabled(!navigationManager.navigateToHome)
            }
            .navigationDestination(isPresented: $navigationManager.navigateToHome) {
                HomeView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
    
    private func handleNavigation() {
//        print("Determining navigation step...")
//        print("Is onboarding completed: \(SessionManager.shared.isOnboardCompleted)")
//        print("Is token valid: \(SessionManager.shared.isTokenValid())")
//        print("Current user: \(String(describing: SessionManager.shared.currentUser))")
        
        if !SessionManager.shared.isOnboardCompleted {
            navigationManager.navigateToOnBoarding = true
        } else if let _ = SessionManager.shared.currentUser, SessionManager.shared.isTokenValid() {
            navigationManager.navigateToHome = true
        } else {
            navigationManager.navigateToAuthentication = true
        }
    }
}

#Preview {
    ContentView().environmentObject(NavigationManager())
}
