//
//  ContentView.swift
//  hitch-edu
//
//  Created by Godson Umoren on 11/18/24.
//

import SwiftUI
import Combine

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isVisible = false // For animation
    
    // Keep a reference to store Combine subscriptions
    @State private var cancellables = Set<AnyCancellable>()
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
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
                        .animation(.easeOut(duration: 1.0), value: isVisible)
                }
                .padding()
            }
            .onAppear {
                // Trigger the splash animation
                isVisible = true
                
                // After some delay, decide where to go
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
                AppView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
    
    private func handleNavigation() {
        // 1) If user hasn't completed onboarding, go there first
        if !SessionManager.shared.isOnboardCompleted {
            navigationManager.navigateToOnBoarding = true
            return
        }
        
        // 2) Check if there's a saved user
        guard let _ = SessionManager.shared.currentUser else {
            // No user => must sign in
            navigationManager.navigateToAuthentication = true
            return
        }
        
        // 3) If we do have a user, see if the token is still valid
        if SessionManager.shared.isTokenValid() {
            // Access token valid => go straight home
            navigationManager.navigateToHome = true
        } else {
            // Access token is expired => attempt a refresh
            SessionManager.shared.refreshTokens()
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .failure:
                        // If refresh fails => we assume refresh token also invalid
                        navigationManager.navigateToAuthentication = true
                    case .finished:
                        break
                    }
                } receiveValue: { _ in
                    // If refresh succeeds => navigate to home
                    navigationManager.navigateToHome = true
                }
                .store(in: &cancellables)
        }
    }
}

#Preview {
    ContentView().environmentObject(NavigationManager())
}
