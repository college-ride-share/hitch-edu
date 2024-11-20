//
//  OnBoardingView.swift
//  hitch-edu
//
//  Created by Godson Umoren on 11/19/24.
//

import SwiftUI

struct OnBoardingView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var navigationManager: NavigationManager // Add NavigationManager as an EnvironmentObject

    
    @State private var isVisible = false
    @State private var modalVisible: Bool = false
    
    var body: some View {
        
        ZStack(alignment:.bottom) {
            Image("MapImage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 50) {
                    VStack(alignment: .leading, spacing: 5) {
                        
                        Text("Welcome to CarShareU!")
                            .font(.geistBlack(size: 25))
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color.appTextPrimary)
                        
                        Text("Simplify your campus travels with ease. Whether you’re sharing a ride or finding one, our app connects you with your college community, making every trip affordable, convenient, and safe. Your journey starts here.")
                            .font(.geistMonoThin(size: 12))
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .foregroundColor(Color.appTextSecondary)
                    }
                    
                    
                    Button{
                        modalVisible = true
                    } label: {
                        Text("Get Started")
                            .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .buttonStyle(.borderless)
                    .frame(maxWidth: .infinity)
                    .background(Color.appPrimary)
                    .cornerRadius(10)
                    .foregroundStyle(.white)
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            .cornerRadius(20)
            .containerRelativeFrame(
                [.horizontal],
                alignment: .topLeading
            )
            
            .background(Color.appBackground)
            .opacity(isVisible ? 1 : 0) // Fade effect
            .offset(y: isVisible ? 0 : 50) // Slide in from the bottom
            .animation(.easeOut(duration: 1.0), value: isVisible) // Apply animation
            .onAppear {
                isVisible = true
            }
            
            
        }
        .sheet(isPresented: $modalVisible) {
            AuthenticationView(
                           authService: AuthService(),
                           navigationManager: navigationManager
                       )
                       .environmentObject(navigationManager)
            
        }
    }
}

#Preview {
    OnBoardingView()
}
