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
                    MoviesView(serviceConfig: settingsVM.config.radarr)
                }
                Tab("Shows", systemImage: "film") {
                    ShowsView(serviceConfig: settingsVM.config.sonarr)
                }
                Tab("Search", systemImage: "magnifyingglass") {
                    SearchView(radarr: settingsVM.config.radarr, sonarr: settingsVM.config.sonarr)
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
