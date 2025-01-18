//
//  ContentView.swift
//  Watcher
//
//  Created by Adrien Freire on 14/12/2024.
//

import SwiftUI
//reflichir a mettre le hide scrollbar partout dans view et dans les sheet
struct ContentView: View {
    @StateObject var settingsVM: SettingsVM = SettingsVM()

    var body: some View {
        TabView {
            if settingsVM.isLocked {
                Tab("Movies", systemImage: "movieclapper") {
                    MoviesView(serviceConfig: settingsVM.config.Radarr)
                }
                Tab("Shows", systemImage: "film") {
                    ShowsView(serviceConfig: settingsVM.config.Sonarr)
                }
                Tab("Search", systemImage: "magnifyingglass") {
                    SearchView(radarr: settingsVM.config.Radarr, sonarr: settingsVM.config.Sonarr)
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
