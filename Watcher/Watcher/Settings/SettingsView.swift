//
//  SettingsView.swift
//  Watcher
//
//  Created by Adrien Freire on 14/12/2024.
//

import SwiftUI

struct SettingsView: View {
    // swiftlint:disable:next identifier_name
    @EnvironmentObject var vm: SettingsVM

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 10) {
                Section("Radarr") {
                    TextField("Api key", text: $vm.config.radarr.apiKey)
                    TextField("Url", text: $vm.config.radarr.url)
                }
                Section("Sabnzbd") {
                    TextField("Api key", text: $vm.config.sabnzbd.apiKey)
                    TextField("Url", text: $vm.config.sabnzbd.url)
                }
                Section("Sonarr") {
                    TextField("Api key", text: $vm.config.sonarr.apiKey)
                    TextField("Url", text: $vm.config.sonarr.url)
                }
            }
            .padding()

            VStack {
                HStack {
                    OptionsView(image: vm.isLocked ? "lock" : "lock.open", text: vm.isLocked ? "Saved" : "Save")
                        .onTapGesture {
                            vm.saveConfigToUserDefaults()
                        }
                    OptionsView(image: "trash", text: "Delete")
                        .onTapGesture {
                            vm.deleteAll()
                        }
                }
                HStack {
                    OptionsView(image: "square.and.arrow.down", text: "Download")
                        .onTapGesture {
                            vm.pickFile.toggle()
                        }
                    OptionsView(image: "square.and.arrow.up", text: "Upload")
                        .onTapGesture {
                            vm.downloadConfigAsJSON()
                        }
                }
            }
            .padding()
        }
        .fileImporter(isPresented: $vm.pickFile, allowedContentTypes: [.json]) { result in
            switch result {
            case .success(let fileURL):
                print(fileURL.absoluteString)
                vm.parseConfig(from: fileURL)

            case .failure(let error):
                print(error)
            }
        }
    }
}

struct OptionsView: View {
    let image: String
    let text: String

    var body: some View {
        ZStack {
            Color.gray.opacity(0.2)
            HStack {
                Image(systemName: image)
                Text(text)
            }
        }
        .clipShape(.buttonBorder)
        .frame(width: 126, height: 42)
    }
}
