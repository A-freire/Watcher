//
//  ContentView.swift
//  Watcher
//
//  Created by Adrien Freire on 14/12/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var settingsVM: SettingsVM = SettingsVM()

    var body: some View {
        TabView {
            if settingsVM.isLocked {
                Tab("Movies", systemImage: "movieclapper") {
                    MoviesView()
                }
                Tab("Shows", systemImage: "film") {
                    ShowsView()
                }
                Tab("Search", systemImage: "magnifyingglass") {
                        
                }
                Tab("Broken", systemImage: "exclamationmark.octagon") {
                    
                }
            }
            
            Tab("Settings", systemImage: "gearshape") {
                SettingsView()
                    .environmentObject(settingsVM)
            }
        }
        .onAppear(perform: {
            settingsVM.loadConfigFromUserDefaults()
        })
    }
}

#Preview {
    ContentView()
}
