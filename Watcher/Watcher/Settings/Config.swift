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
}

struct Config: Codable {
    var Radarr: ServiceConfig
    var Sabnzbd: ServiceConfig
    var Sonarr: ServiceConfig
}
