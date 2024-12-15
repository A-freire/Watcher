//
//  SettingsView.swift
//  Watcher
//
//  Created by Adrien Freire on 14/12/2024.
//

import SwiftUI

struct SettingsView: View {
    @State var config: Config
    @State var pickFile: Bool = false
    @State var isLocked: Bool = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 10){
                Section("Radarr"){
                    TextField("Api key", text: $config.Radarr.apiKey)
                    TextField("Url", text: $config.Radarr.url)
                }
                Section("Sabnzbd"){
                    TextField("Api key", text: $config.Sabnzbd.apiKey)
                    TextField("Url", text: $config.Sabnzbd.url)
                }
                Section("Sonarr"){
                    TextField("Api key", text: $config.Sonarr.apiKey)
                    TextField("Url", text: $config.Sonarr.url)
                }
            }
            .padding()
            
            VStack {
                HStack {
                    OptionsView(image: isLocked ? "lock" : "lock.open", text: "Save")
                        .onTapGesture {
                            saveConfigToUserDefaults()
                        }
                    OptionsView(image: "trash", text: "Delete")
                        .onTapGesture {
                            deleteAll()
                        }
                }
                HStack {
                    OptionsView(image: "square.and.arrow.down", text: "Download")
                        .onTapGesture {
                            pickFile.toggle()
                        }
                    OptionsView(image: "square.and.arrow.up", text: "Upload")
                        .onTapGesture {
                            downloadConfigAsJSON()
                        }
                }
            }
            .padding()
        }
        .onAppear(perform: {
            loadConfigFromUserDefaults()
        })
        .fileImporter(isPresented: $pickFile, allowedContentTypes: [.json]) { result in
            switch result {
            case .success(let fileURL):
                print(fileURL.absoluteString)
                parseConfig(from: fileURL)

            case .failure(let error):
                print(error)
            }
        }
    }

    func parseConfig(from fileURL: URL) {
        guard fileURL.startAccessingSecurityScopedResource() else { return }
        defer { fileURL.stopAccessingSecurityScopedResource() }

        do {
            // Lire le contenu du fichier
            let data = try Data(contentsOf: fileURL)
            // Décoder le JSON en structure Swift
            let config = try JSONDecoder().decode(Config.self, from: data)
            self.config = config
        } catch {
            print("Erreur lors de la lecture ou du parsing du JSON : \(error)")
            return
        }
    }
    
    func saveConfigToUserDefaults() {
        do {
            let data = try JSONEncoder().encode(config)
            UserDefaults.standard.set(data, forKey: "ConfigData")
            withAnimation {
                isLocked.toggle()
            }
        } catch {
            print("Erreur lors de l'encodage de la configuration: \(error)")
        }
    }
    
    func loadConfigFromUserDefaults() {
        guard let data = UserDefaults.standard.data(forKey: "ConfigData") else { return }
        do {
            config = try JSONDecoder().decode(Config.self, from: data)
            isLocked.toggle()
        } catch {
            print("Erreur lors du décodage de la configuration: \(error)")
        }
    }
    
    func deleteAll() {
        config = Config(Radarr: ServiceConfig(apiKey: "", url: ""), Sabnzbd: ServiceConfig(apiKey: "", url: ""), Sonarr: ServiceConfig(apiKey: "", url: ""))
        isLocked.toggle()
        UserDefaults.standard.removeObject(forKey: "ConfigData")
    }

    func downloadConfigAsJSON(fileName: String = "config.json") {
            do {
                let jsonData = try JSONEncoder().encode(config)
                let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
                
                // Création de l'URL temporaire
                let tempDirectory = FileManager.default.temporaryDirectory
                let fileURL = tempDirectory.appendingPathComponent(fileName)
                
                // Écriture du fichier JSON
                try jsonString.write(to: fileURL, atomically: true, encoding: .utf8)
                
                // Présentation de la feuille de partage pour télécharger
                let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
                if let topController = UIApplication.shared.windows.first?.rootViewController {
                    topController.present(activityVC, animated: true, completion: nil)
                }
            } catch {
                print("Erreur lors de la création du fichier JSON: \(error)")
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










#Preview {
    SettingsView(config: Config(Radarr: ServiceConfig(apiKey: "", url: ""), Sabnzbd: ServiceConfig(apiKey: "", url: ""), Sonarr: ServiceConfig(apiKey: "", url: "")))
}
