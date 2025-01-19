//
//  ShowsVM.swift
//  Watcher
//
//  Created by Adrien Freire on 29/12/2024.
//

import Foundation

class ShowsVM: ObservableObject {
    @Published var spaceLeft: Int = 0
    @Published var search: String = ""
    @Published var eraseMode: Bool = false
    @Published var shows: [Show] = []
    @Published var status: [Int:Status] = [:]
    @Published private var delete: [Int] = []
    @Published var confirmErase: Bool = false

    private var sonarr: ServiceConfig

    var searchedShows: [Show] {
        guard !search.isEmpty else { return shows }
        return shows.filter { show in
            if show.getTitle.contains(search) {
                return true
            } else if show.getAlternateTitles.contains(where: { $0.getTitle.contains(search) }) {
                return true
            }
            return false
        }
    }
    
    init(sonarr: ServiceConfig) {
        self.sonarr = sonarr
    }

    func getShowStatus(id: Int) -> Status {
        return status[id] ?? .unavailable
    }
    
    @MainActor func getSizeLeft() {
        SpaceLeftManager(config: sonarr).getSizeLeft { space in
            self.spaceLeft = space
        }
    }

    @MainActor func fetchInit() {
        Task {
            await fetchShows()
            await QueueManager.shared.getQueue(config: sonarr)
            self.status = await QueueManager.shared.getDlStatus(shows: shows)
        }
    }

    @MainActor private func fetchShows() async {
        guard !sonarr.isEmpty else { return }
        
        var request = URLRequest(url: URL(string: "\(sonarr.url)/api/v3/series")!)
        request.addValue(sonarr.apiKey, forHTTPHeaderField: "Authorization")
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {  print("Response error: fetchShows"); return }

            shows = try JSONDecoder().decode([Show].self, from: data).reversed()
        } catch {
            print("fetchShow catch fail")
            return
        }
    }
    
    func initShowVM(show: Show) -> ShowVM {
        ShowVM(show: show, sonarr: sonarr)
    }
}

extension ShowsVM {
    func isSelected(id: Int) -> Bool {
        eraseMode && delete.contains(id)
    }

    func modifyDelete(id: Int) {
        if let i = delete.firstIndex(of: id) {
            delete.remove(at: i)
        } else {
            delete.append(id)
        }
    }

    func manageDelete() {
        if !delete.isEmpty {
            confirmErase.toggle()
        }
        eraseMode.toggle()
    }
    
    @MainActor func deleteAll(erase: Bool) {
        QueueManager.shared.deleteFromQueue(config: sonarr, eps: delete)
        for id in delete {
            deleteShows(id: id)
            if erase {
                shows = shows.filter { !delete.contains($0.getId) }
                eraseShow(id: id)
            }
        }
        freeDelete()
    }

    func freeDelete() {
        delete = []
    }

    @MainActor private func deleteShows(id: Int) {
        Task {
            await fetchEpisodes(id: id)
        }
    }

    private func fetchEpisodes(id: Int) async {
        guard !sonarr.isEmpty else { return }
        
        var request = URLRequest(url: URL(string: "\(sonarr.url)/api/v3/episode?seriesId=\(id)")!)
        request.addValue(sonarr.apiKey, forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {  print("Response error: fetchEpisodes"); return }
            let eps = try JSONDecoder().decode([Episode].self, from: data).compactMap({$0.getEpisodeFileId != 0 ? $0.getEpisodeFileId : nil })
            guard !eps.isEmpty else { return }
            await deleteSeasons(eps: eps)
        } catch {
            print("fetchEpisodes catch fail")
            return
        }
    }

    private func deleteSeasons(eps: [Int]) async {
        guard !sonarr.isEmpty else { return }

        var request = URLRequest(url: URL(string: "\(sonarr.url)/api/v3/episodeFile/bulk")!)
        request.addValue(sonarr.apiKey, forHTTPHeaderField: "Authorization")
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONEncoder().encode(EpisodeFile(episodeFileIds: eps))
            let (_, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {  print("Response error: deleteSeason"); return }
        } catch {
            print("deleteSeasons catch fail")
            return
        }
    }
    
    @MainActor func eraseShow(id: Int) {
        guard !sonarr.isEmpty else { return }

        var request = URLRequest(url: URL(string: "\(sonarr.url)/api/v3/series/\(id)?deleteFiles=true")!)
        request.addValue(sonarr.apiKey, forHTTPHeaderField: "Authorization")
        request.httpMethod = "DELETE"
        Task {
            do {
                let (_, response) = try await URLSession.shared.data(for: request)

                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {  print("Response error: eraseShow"); return }
            } catch {
                print("eraseShow catch fail")
                return
            }
        }
    }
}
