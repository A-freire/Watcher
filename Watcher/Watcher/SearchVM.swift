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
    
    func fetchMovies() async {
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
    func fetchShows() async {
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
    
    func addMovie(movie: Movie) {
        guard !radarr.isEmpty else { return }
        
        var request = URLRequest(url: URL(string: "\(radarr.url)/api/v3/movie")!)
        request.addValue(radarr.apiKey, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        Task {
            do {
                request.httpBody = try JSONEncoder().encode(movie.copyToAdd())

                let (data, response) = try await URLSession.shared.data(for: request)
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 201 {
                    let statusCode = httpResponse.statusCode
                    let errorMessage = String(data: data, encoding: .utf8) ?? "No error message"
                    
                    print("❌ Response error: addMovie - Code: \(statusCode) - Message: \(errorMessage)")
                    return
                }
                let mov = try JSONDecoder().decode(Movie.self, from: data)
                movies = movies.compactMap({ if $0 == movie { return mov }; return $0 })
                await commandMovie(id: mov.getId)
            } catch {
                print("❌ addMovie catch fail")
                return
            }
        }
    }
    func commandMovie(id: Int) async {
        guard !radarr.isEmpty else { return }
        
        var request = URLRequest(url: URL(string: "\(radarr.url)/api/v3/command")!)
        request.addValue(radarr.apiKey, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONEncoder().encode(MoviesCommand(name: "MoviesSearch", movieIds: [id]))

            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 201 {
                let statusCode = httpResponse.statusCode
                let errorMessage = String(data: data, encoding: .utf8) ?? "No error message"
                
                print("❌ Response error: addMovie - Code: \(statusCode) - Message: \(errorMessage)")
                return
            }
            
        } catch {
            print("commandMovie catch fail")
            return
        }
    }
    
    func addShow(show: Show) {
        guard !sonarr.isEmpty else { return }
        
        var request = URLRequest(url: URL(string: "\(sonarr.url)/api/v3/series")!)
        request.addValue(sonarr.apiKey, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        Task {
            do {
                print(show.copyToAdd())
                request.httpBody = try JSONEncoder().encode(show.copyToAdd())

                let (data, response) = try await URLSession.shared.data(for: request)
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 201 {
                    let statusCode = httpResponse.statusCode
                    let errorMessage = String(data: data, encoding: .utf8) ?? "No error message"
                    
                    print("❌ Response error: addShow - Code: \(statusCode) - Message: \(errorMessage)")
                    return
                }
                let cho = try JSONDecoder().decode(Show.self, from: data)
                shows = shows.map({ if $0 == show { return cho }; return $0 })
                await commandShow(id: cho.getId)
            } catch {
                print("❌ addShow catch fail")
                return
            }
        }
    }
    func commandShow(id: Int) async {
        guard !sonarr.isEmpty else { return }
        
        var request = URLRequest(url: URL(string: "\(sonarr.url)/api/v3/command")!)
        request.addValue(sonarr.apiKey, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONEncoder().encode(SeriesCommand(name: "SeriesSearch", seriesId: id))

            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 201 {
                let statusCode = httpResponse.statusCode
                let errorMessage = String(data: data, encoding: .utf8) ?? "No error message"
                
                print("❌ Response error: addMovie - Code: \(statusCode) - Message: \(errorMessage)")
                return
            }
            
        } catch {
            print("commandMovie catch fail")
            return
        }
    }

}

struct MoviesCommand: Codable {
    let name: String
    let movieIds: [Int]
}
