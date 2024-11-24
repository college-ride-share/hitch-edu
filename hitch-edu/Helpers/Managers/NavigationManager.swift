//
//  NavigationManager.swift
//  hitch-edu
//
//  Created by Godson Umoren on 11/20/24.
//

import Foundation
import SwiftUI

class NavigationManager: ObservableObject {
    @Published var navigateToOnBoarding = false
    @Published var navigateToAuthentication = false
    @Published var navigateToHome = false
    
     func resetNaviagation() {
        navigateToOnBoarding = false
        navigateToAuthentication = false
        navigateToHome = false
    }
}
