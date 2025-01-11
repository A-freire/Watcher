//
//  SpaceLeftManager.swift
//  Watcher
//
//  Created by Adrien Freire on 21/12/2024.
//

import Foundation

struct FreeSpace: Codable {
    let id: Int
//    let path: String
//    let accessible: Bool
    let freeSpace: Double
}

class SpaceLeftManager {
    var config: ServiceConfig
    
    init(config: ServiceConfig) {
        self.config = config
    }
    
    @MainActor func getSizeLeft(completion: @escaping (Int) -> Void) {
        guard !config.isEmpty else { return }
        
        var request = URLRequest(url: URL(string: "\(config.url)/api/v3/rootfolder")!)
        request.addValue(config.apiKey, forHTTPHeaderField: "Authorization")
        Task {
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { print("Response error: getSizeLeft"); return }
                
                let list = try JSONDecoder().decode([FreeSpace].self, from: data)
                
                guard let space = list.first?.freeSpace else { return }
                
                completion(Int(space * 0.000000001))
            } catch {
                return
            }
        }
    }

}
