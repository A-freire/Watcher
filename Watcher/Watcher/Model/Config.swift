//
//  Config.swift
//  Watcher
//
//  Created by Adrien Freire on 14/12/2024.
//

import Foundation

struct ServiceConfig: Codable {
    var apiKey: String
    var url: String
    var isEmpty: Bool {
        apiKey.isEmpty || url.isEmpty
    }
}

struct Config: Codable {
    var radarr: ServiceConfig
    var sabnzbd: ServiceConfig
    var sonarr: ServiceConfig
    var isEmpty: Bool {
        radarr.isEmpty || sabnzbd.isEmpty || sonarr.isEmpty
    }
}
