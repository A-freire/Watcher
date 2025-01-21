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
        self.config =  Config(
            radarr: ServiceConfig(
                apiKey: "",
                url: ""
            ),
            sabnzbd: ServiceConfig(
                apiKey: "",
                url: ""
            ),
            sonarr: ServiceConfig(
                apiKey: "",
                url: ""
            )
        )
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
        config = Config(
            radarr: ServiceConfig(
                apiKey: "",
                url: ""
            ),
            sabnzbd: ServiceConfig(
                apiKey: "",
                url: ""
            ),
            sonarr: ServiceConfig(
                apiKey: "",
                url: ""
            )
        )
        isLocked.toggle()
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }

    @MainActor func downloadConfigAsJSON(fileName: String = "config.json") {
        do {
            let jsonData = try JSONEncoder().encode(config)
            let jsonString = String(data: jsonData, encoding: .utf8) ?? ""

            // Création de l'URL temporaire
            let tempDirectory = FileManager.default.temporaryDirectory
            let fileURL = tempDirectory.appendingPathComponent(fileName)

            // Écriture du fichier JSON
            try jsonString.write(to: fileURL, atomically: true, encoding: .utf8)

            // Vérification si le fichier a bien été créé
            guard FileManager.default.fileExists(atPath: fileURL.path) else {
                print("⚠️ Le fichier JSON n'a pas été correctement créé.")
                return
            }

            // Présentation de la feuille de partage
            let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)

            if let topController = getTopViewController() {
                // 🛑 Fix pour éviter le crash sur iPad
                if let popoverController = activityVC.popoverPresentationController {
                    popoverController.sourceView = topController.view
                    popoverController.sourceRect = CGRect(
                        x: topController.view.bounds.midX,
                        y: topController.view.bounds.midY,
                        width: 0,
                        height: 0
                    )
                    popoverController.permittedArrowDirections = []
                }

                topController.present(activityVC, animated: true, completion: nil)
            } else {
                print("⚠️ Impossible de trouver un contrôleur valide pour présenter l'activité.")
            }
        } catch {
            print("❌ Erreur lors de la création du fichier JSON: \(error)")
        }
    }

    // Fonction utilitaire pour récupérer le contrôleur actuellement affiché
    @MainActor func getTopViewController() -> UIViewController? {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first,
              let rootViewController = window.rootViewController else {
            return nil
        }

        var topController: UIViewController = rootViewController
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        return topController
    }
}
