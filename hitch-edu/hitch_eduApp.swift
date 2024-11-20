//
//  hitch_eduApp.swift
//  hitch-edu
//
//  Created by Godson Umoren on 11/18/24.
//

import SwiftUI

@main
struct hitch_eduApp: App {
    let persistenceController = PersistenceController.shared
    @Environment(\.colorScheme) var colorScheme
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
    private func configureStatusBarStyle() {
        UINavigationBar.appearance().barStyle = colorScheme == .dark ? .black : .default;
    }
    
}
