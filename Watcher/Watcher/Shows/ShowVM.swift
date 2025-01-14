//
//  ShowVM.swift
//  Watcher
//
//  Created by Adrien Freire on 31/12/2024.
//

import Foundation

class ShowVM: ObservableObject {
    @Published var show: Show
    @Published var episodes: [Episode] = []
    private var sonarr: ServiceConfig

    init(show: Show, sonarr: ServiceConfig) {
        self.show = show
        self.sonarr = sonarr
    }

    func getEpSeason(number: Int) -> [Episode] {
        episodes.filter({$0.seasonNumber == number})
    }
    
    @MainActor func fetchShow() async {
        guard !sonarr.isEmpty else { return }
        
        var request = URLRequest(url: URL(string: "\(sonarr.url)/api/v3/series/\(show.id)")!)
        request.addValue(sonarr.apiKey, forHTTPHeaderField: "Authorization")
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {  print("Response error: fetchShow"); return }

            show = try JSONDecoder().decode(Show.self, from: data)
        } catch {
            print("fetchShow catch fail")
            return
        }
    }
    
    @MainActor func monitorSeason(sID: Int) {
        let i = show.seasons.firstIndex(where: { $0.getSeasonNumber == sID})!

        self.show.seasons[i].monitored?.toggle()

        var request = URLRequest(url: URL(string: "\(sonarr.url)/api/v3/series/\(show.id)")!)
        request.addValue(sonarr.apiKey, forHTTPHeaderField: "Authorization")
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var req = URLRequest(url: URL(string: "\(sonarr.url)/api/v3/command")!)
        req.httpMethod = "POST"
        req.addValue(sonarr.apiKey, forHTTPHeaderField: "Authorization")
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        Task {
            do {
                let json = try JSONEncoder().encode(self.show)
                request.httpBody = json
                
                let (_, response) = try await URLSession.shared.data(for: request)

                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 202 else { print("Response error: monitorSeason 1"); return }
                
                if self.show.seasons[i].getMonitored {
                    let json = SeriesCommand(name: "SeriesSearch", seriesId: show.id)
                    req.httpBody = try JSONEncoder().encode(json)
                    let (_, resp) = try await URLSession.shared.data(for: req)
                    
                    guard let httpResponse = resp as? HTTPURLResponse, httpResponse.statusCode == 201 else { print("Response error: monitorSeason 2"); return }
                }
            } catch {
                print("monitorSeason catch fail")
                return
            }
        }
    }
    
    @MainActor func deleteSeason(seasonNumber: Int) {
        guard !sonarr.isEmpty else { return }

        let json = EpisodeFile(episodeFileIds: episodes.compactMap({$0.seasonNumber == seasonNumber && $0.getEpisodeFileId != 0 ? $0.getEpisodeFileId : nil }))
        
        guard !json.episodeFileIds.isEmpty else { return }

        var request = URLRequest(url: URL(string: "\(sonarr.url)/api/v3/episodeFile/bulk")!)
        request.addValue(sonarr.apiKey, forHTTPHeaderField: "Authorization")
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        Task {
            do {
                
                request.httpBody = try JSONEncoder().encode(json)
                let (_, response) = try await URLSession.shared.data(for: request)
                print(json)
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {  print("Response error: deleteSeason"); return }
                
                guard let i = show.seasons.firstIndex(where: {$0.getSeasonNumber == seasonNumber}) else { return }

                show.seasons[i].statistics = Statistics.default

            } catch {
                print("deleteSeason catch fail")
                return
            }
        }
    }

    @MainActor func fetchEpisodes() async {
        guard !sonarr.isEmpty else { return }
        
        var request = URLRequest(url: URL(string: "\(sonarr.url)/api/v3/episode?seriesId=\(show.id)")!)
        request.addValue(sonarr.apiKey, forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {  print("Response error: fetchEpisodes"); return }

            episodes = try JSONDecoder().decode([Episode].self, from: data)
        } catch {
            print("fetchEpisodes catch fail")
            return
        }
    }
}

struct SeriesCommand: Codable {
    let name: String
    let seriesId: Int
}

struct EpisodeFile: Codable {
    let episodeFileIds: [Int]
}
