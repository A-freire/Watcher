//
//  SettingsVM.swift
//  Watcher
//
//  Created by Adrien Freire on 15/12/2024.
//

import Foundation
import SwiftUI

class SettingsVM: ObservableObject {
    @Published var config: Config
    @Published var pickFile: Bool = false
    @Published var isLocked: Bool = false
    
    private let userDefaultsKey = "ConfigData"

    init() {
        self.config =  Config(Radarr: ServiceConfig(apiKey: "", url: ""), Sabnzbd: ServiceConfig(apiKey: "", url: ""), Sonarr: ServiceConfig(apiKey: "", url: ""))
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
        guard !config.isEmpty, !isLocked else { return }
        do {
            let data = try JSONEncoder().encode(config)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
            withAnimation {
                isLocked.toggle()
            }
        } catch {
            print("Erreur lors de l'encodage de la configuration: \(error)")
        }
    }
    
    func loadConfigFromUserDefaults() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else { return }
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
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
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
    
    func isSet() -> Bool {
        UserDefaults.standard.data(forKey: userDefaultsKey) != nil
    }
}
