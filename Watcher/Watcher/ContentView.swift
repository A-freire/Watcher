//
//  ContentView.swift
//  Watcher
//
//  Created by Adrien Freire on 14/12/2024.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
//            SettingsView(config: )
            SettingsView(config: Config(Radarr: ServiceConfig(apiKey: "", url: ""), Sabnzbd: ServiceConfig(apiKey: "", url: ""), Sonarr: ServiceConfig(apiKey: "", url: "")))
        }
    }
}

#Preview {
    ContentView()
}
