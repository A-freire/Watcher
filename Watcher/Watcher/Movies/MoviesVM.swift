//
//  MoviesVM.swift
//  Watcher
//
//  Created by Adrien Freire on 20/12/2024.
//

import Foundation

class MoviesVM: ObservableObject {
    @Published var spaceLeft: Int = 0
    @Published var search: String = ""
    @Published var eraseMode: Bool = false
    @Published var movies: [Movie] = []

    private var radarr: ServiceConfig
    
    init(radarr: ServiceConfig) {
        self.radarr = radarr
    }
    
    @MainActor func getSizeLeft() {
        SpaceLeftManager(config: radarr).getSizeLeft { space in
            self.spaceLeft = space
        }
    }

    @MainActor func fetchMovies() {
        guard !radarr.isEmpty else { return }
        
        var request = URLRequest(url: URL(string: "\(radarr.url)/api/v3/movie")!)
        request.addValue(radarr.apiKey, forHTTPHeaderField: "Authorization")
        Task {
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { return }

                movies = try JSONDecoder().decode([Movie].self, from: data)
                
                movies.sort { $0.getAdded > $1.getAdded }
            } catch {
                return
            }
        }
    }
    
    func getQueue() {
        
    }
}
