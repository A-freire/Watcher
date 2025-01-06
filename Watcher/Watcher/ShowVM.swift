//
//  ShowVM.swift
//  Watcher
//
//  Created by Adrien Freire on 31/12/2024.
//

import Foundation

class ShowVM: ObservableObject {
    @Published var show: Show
    private var sonarr: ServiceConfig

    init(show: Show, sonarr: ServiceConfig) {
        self.show = show
        self.sonarr = sonarr
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
            return
        }
    }
    
    @MainActor func monitorSeason(sID: Int) {
        let i = show.seasons!.firstIndex(where: { $0.getSeasonNumber == sID})!

        self.show.seasons![i].monitored?.toggle()

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
                
                if self.show.seasons![i].getMonitored {
                    let json = SeriesCommand(name: "SeriesSearch", seriesId: show.id)
                    req.httpBody = try JSONEncoder().encode(json)
                    
                    let (_, resp) = try await URLSession.shared.data(for: req)
                    
                    guard let httpResponse = resp as? HTTPURLResponse, httpResponse.statusCode == 201 else { print("Response error: monitorSeason 2"); return }
                }
//                let yo = try JSONDecoder().decode(Show.self, from: data)
//                if let index = self.shows.firstIndex(where: { $0.id == yo.id }) {
//                    self.shows[index] = yo
//                }
            } catch {
                return
            }
        }
    }

}

struct SeriesCommand: Codable {
    let name: String
    let seriesId: Int
}
