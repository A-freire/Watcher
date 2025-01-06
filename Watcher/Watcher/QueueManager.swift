//
//  QueueManager.swift
//  Watcher
//
//  Created by Adrien Freire on 26/12/2024.
//

import Foundation

actor QueueManager {
    static let shared = QueueManager()
    
    private init() {}
    
    private(set) var queue: [Record] = []
    
    func getQueue(config: ServiceConfig) {
        guard !config.isEmpty else { return }
        
        var request = URLRequest(url: URL(string: "\(config.url)/api/v3/queue")!)
        request.addValue(config.apiKey, forHTTPHeaderField: "Authorization")
        Task {
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { print("Response error: getQueue"); return }
                
                let list = try JSONDecoder().decode(Queue.self, from: data)
                
                queue = list.getRecords
            } catch {
                return
            }
        }
    }
    
    @MainActor func deleteFromQueue(config: ServiceConfig, moviesID: [Int]) {
        guard !config.isEmpty else { return }
        
        var request = URLRequest(url: URL(string: "\(config.url)/api/v3/queue/bulk")!)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(config.apiKey, forHTTPHeaderField: "Authorization")
        
        Task {
            await getQueue(config: config)
            do {
                let ids = await queue.compactMap { record in
                    if moviesID.contains(where: { $0 == record.getMovieId }) {
                        return record.id
                    }
                    return nil
                }
                let jsonData = try JSONEncoder().encode(Bulk(ids: ids))
                request.httpBody = jsonData
                let (_, response) = try await URLSession.shared.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { print("Response error: deleteFromQueue"); return }
            } catch {
                return
            }
        }
    }

    func getDlStatus(movies: [Movie]) -> [Int:Status] {
        var status: [Int:Status] = [:]
        for movie in movies {
            let queue = queue.contains(where: { $0.getMovieId == movie.getId })

            if !queue {
                if movie.getHasFile {
                    status[movie.getId] = .downloaded
                } else if (!movie.getHasFile && movie.getIsAvailable) {
                    status[movie.getId] = .missing
                } else {
                    status[movie.getId] = .unavailable
                }
            } else {
                status[movie.getId] = .queued
            }
        }
        return status
    }

    func getDlStatus(shows: [Show]) -> [Int:Status] {
        var status: [Int:Status] = [:]
        for show in shows {
            let queue = queue.contains(where: { $0.getSeriesId == show.id })

            if !queue {
                if show.getHasFiles && show.getEnded {
                    status[show.id] = .downloaded
                } else if show.getHasFiles && !show.getEnded {
                    status[show.id] = .airing
                } else if (!show.getHasFiles && show.getIsAvailable) {
                    status[show.id] = .missing
                } else {
                    status[show.id] = .unavailable
                }
            } else {
                status[show.id] = .queued
            }
        }
        return status
    }
}

struct Bulk: Codable {
    let ids: [Int]
}
