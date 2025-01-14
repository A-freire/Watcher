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
    @Published var confirmErase: Bool = false
    @Published var movies: [Movie] = []
    @Published private var delete: [Int] = []
    @Published var status: [Int:Status] = [:]
    
    private var radarr: ServiceConfig
    
    var searchedMovies: [Movie] {
        guard !search.isEmpty else { return movies }
        return movies.filter { movie in
            if movie.getTitle.contains(search) {
                return true
            } else if movie.getAlternateTitles.contains(where: { $0.getTitle.contains(search) }) {
                return true
            }
            return false
        }
    }
    
    init(radarr: ServiceConfig) {
        self.radarr = radarr
    }

    func isSelected(id: Int) -> Bool {
        eraseMode && delete.contains(id)
    }
    
    func getMovieStatus(id: Int) -> Status {
        return status[id] ?? .unavailable
    }

    @MainActor func getSizeLeft() {
        SpaceLeftManager(config: radarr).getSizeLeft { space in
            self.spaceLeft = space
        }
    }

    @MainActor private func fetchMovies() async {
        guard !radarr.isEmpty else { return }
        
        var request = URLRequest(url: URL(string: "\(radarr.url)/api/v3/movie")!)
        request.addValue(radarr.apiKey, forHTTPHeaderField: "Authorization")
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {  print("Response error: fetchMovies"); return }

            movies = try JSONDecoder().decode([Movie].self, from: data).reversed()
        } catch {
            print("fetchMovies catch fail")
            return
        }
    }

//    @MainActor func refreshQueue() {
//        Task {
//            await QueueManager.shared.getQueue(config: radarr)
//        }
//    }
//
//    @MainActor func refreshStatus() {
//        Task {
//            self.status = await QueueManager.shared.getDlStatus(movies: movies)
//        }
//    }

    @MainActor func fetchInit() {
        Task {
            await fetchMovies()
            await QueueManager.shared.getQueue(config: radarr)
            self.status = await QueueManager.shared.getDlStatus(movies: movies)
        }
    }

    func manageDelete() {
        if !delete.isEmpty {
            confirmErase.toggle()
        }
        eraseMode.toggle()
    }

    func modifyDelete(id: Int) {
        if let i = delete.firstIndex(of: id) {
            delete.remove(at: i)
        } else {
            delete.append(id)
        }
    }
    
    @MainActor func deleteAll() {
        movies = movies.filter { !delete.contains($0.getId) }
        QueueManager.shared.deleteFromQueue(config: radarr, moviesID: delete)
        for id in delete {
            deleteMovie(id: id)
        }
        freeDelete()
    }

    func freeDelete() {
        delete = []
    }

    func deleteMovie(id: Int) {
        guard !radarr.isEmpty else { return }
        
        var request = URLRequest(url: URL(string: "\(radarr.url)/api/v3/movie/\(id)?deleteFiles=true")!)
        request.httpMethod = "DELETE"
        request.addValue(radarr.apiKey, forHTTPHeaderField: "Authorization")
        Task {
            do {
                let (_, response) = try await URLSession.shared.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { print("Response error: deleteMovie"); return }
            } catch {
                print("deleteMovie catch fail")
                return
            }
        }
    }
}
