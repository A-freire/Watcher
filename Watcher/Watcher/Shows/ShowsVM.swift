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
            return
        }
    }
    
    func initShowVM(show: Show) -> ShowVM {
        ShowVM(show: show, sonarr: sonarr)
    }
}
