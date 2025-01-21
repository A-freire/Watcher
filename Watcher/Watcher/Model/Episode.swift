//
//  Episode.swift
//  Watcher
//
//  Created by Adrien Freire on 06/01/2025.
//

import Foundation

struct Episode: Codable, Hashable {
    let seriesId: Int?
    let episodeFileId: Int?
    let seasonNumber: Int?
    let episodeNumber: Int?
    let title: String?
    let airDate: String?
    let airDateUtc: String?
    let overview: String?
    let hasFile: Bool?
    let monitored: Bool?
    let absoluteEpisodeNumber: Int?
    let unverifiedSceneNumbering: Bool?
    let id: Int
}

extension Episode {
    var getSeriesId: Int {
        seriesId ?? 0
    }

    var getEpisodeFileId: Int {
        episodeFileId ?? 0
    }

    var getSeasonNumber: Int {
        seasonNumber ?? 0
    }

    var getEpisodeNumber: Int {
        episodeNumber ?? 0
    }

    var getTitle: String {
        title ?? "Unknown Title"
    }

    var getAirDate: String {
        airDate ?? "Unknown Air Date"
    }

    var getAirDateUtc: String {
        airDateUtc ?? "Unknown UTC Date"
    }

    var getOverview: String {
        overview ?? "No Overview"
    }

    var getHasFile: Bool {
        hasFile ?? false
    }

    var getMonitored: Bool {
        monitored ?? false
    }

    var getAbsoluteEpisodeNumber: Int {
        absoluteEpisodeNumber ?? 0
    }

    var getUnverifiedSceneNumbering: Bool {
        unverifiedSceneNumbering ?? false
    }
}
