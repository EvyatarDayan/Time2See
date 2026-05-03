//
//  Time2SeeApp.swift
//  Time2See
//
//  Created by EVYATAR DAYAN on 17/07/2025.
//

import SwiftUI

@main
struct Time2SeeApp: App {
    @StateObject private var settingsManager = SettingsManager()
    @State private var showLogo = true
    
    var body: some Scene {
        WindowGroup {
            if showLogo {
                LogoView {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showLogo = false
                    }
                }
            } else {
                ContentView()
                    .environmentObject(settingsManager)
                    .preferredColorScheme(settingsManager.isDarkMode ? .dark : .light)
                    .transition(.opacity)
            }
        }
    }
}
