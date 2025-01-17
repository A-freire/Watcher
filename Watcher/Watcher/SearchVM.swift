//
//  SearchVM.swift
//  Watcher
//
//  Created by Adrien Freire on 08/01/2025.
//

import Foundation

@MainActor
class SearchVM: ObservableObject {
    var search: String = "" {
        didSet {
            if search.count > 2 {
                debounceInput()
            }
        }
    }
    @Published var state: Bool = false
    @Published var movies: [Movie] = []
    @Published var shows: [Show] = []

    var data: SearchParam {
        if state {
            return .shows(shows)
        }
        return .movies(movies)
    }
    
    private var currentTask: Task<Void, Never>? = nil
    private var radarr: ServiceConfig
    private var sonarr: ServiceConfig

    init(radarr: ServiceConfig, sonarr: ServiceConfig) {
        self.radarr = radarr
        self.sonarr = sonarr
    }

    func debounceInput() {
        currentTask?.cancel()
        
        currentTask = Task {
            try? await Task.sleep(nanoseconds: 200_000_000)
            
            guard !Task.isCancelled else { return }

            switch state{
            case true:
                await fetchShows()
            case false:
                await fetchMovies()
            }
        }
    }
    
    @MainActor func fetchMovies() async {
        guard !radarr.isEmpty else { return }
        
        var request = URLRequest(url: URL(string: "\(radarr.url)/api/v3/movie/lookup?term=\(search)")!)
        request.addValue(radarr.apiKey, forHTTPHeaderField: "Authorization")
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {  print("Response error: fetchMovies"); return }
            let datas = try JSONDecoder().decode([Movie].self, from: data)
            movies = datas.filter({ $0.gotReleased })
        } catch {
            print("fetchMovies catch fail")
            return
        }
    }    
    @MainActor func fetchShows() async {
        guard !sonarr.isEmpty else { return }
        
        var request = URLRequest(url: URL(string: "\(sonarr.url)/api/v3/series/lookup?term=\(search)")!)
        request.addValue(sonarr.apiKey, forHTTPHeaderField: "Authorization")
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {  print("Response error: fetchMovies"); return }
            let datas = try JSONDecoder().decode([Show].self, from: data)
            shows = datas.filter({ $0.gotReleased })
        } catch {
            print("fetchShows catch fail")
            return
        }
    }
}
