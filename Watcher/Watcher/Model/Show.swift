//
//  Show.swift
//  Watcher
//
//  Created by Adrien Freire on 29/12/2024.
//

import Foundation

struct Show: Codable, Hashable {
    let id: Int?
    let title: String?
    let alternateTitles: [AlternateTitleShow]?
    let sortTitle: String?
    let status: String?
    let ended: Bool?
    let profileName: String?
    let overview: String?
    let nextAiring: String?
    let previousAiring: String?
    let network: String?
    let airTime: String?
    let images: [Cover]
    let languageProfileId: Int?
    let remotePoster: String?
    var seasons: [Season]
    let year: Int?
    let path: String?
    let qualityProfileId: Int?
    let seasonFolder: Bool?
    let monitored: Bool?
    let monitorNewItems: String?
    let useSceneNumbering: Bool?
    let runtime: Int?
    let tvdbId: Int?
    let tvRageId: Int?
    let tvMazeId: Int?
    let tmdbId: Int?
    let firstAired: String?
    let lastAired: String?
    let seriesType: String?
    let cleanTitle: String?
    let imdbId: String?
    let titleSlug: String?
    let rootFolderPath: String?
    let folder: String?
    let certification: String?
    let genres: [String]
    let tags: [Int]
    let added: String?
    let addOptions: AddOptions?
    let ratings: Ratings?
    let statistics: Statistics?
    let episodesChanged: Bool?
}

struct AlternateTitleShow: Codable, Hashable {
    let title: String?
    let seasonNumber: Int?
    let sceneSeasonNumber: Int?
    let sceneOrigin: String?
    let comment: String?
}

struct Season: Codable, Hashable {
    let seasonNumber: Int?
    var monitored: Bool?
    var statistics: Statistics?
    let images: [Cover]?
}

struct Statistics: Codable, Hashable {
    let seasonCount: Int?
    let nextAiring: String?
    let previousAiring: String?
    let episodeFileCount: Int?
    let episodeCount: Int?
    let totalEpisodeCount: Int?
    let sizeOnDisk: Double?
    let releaseGroups: [String]?
    let percentOfEpisodes: Double?
}

struct AddOptions: Codable, Hashable {
    let ignoreEpisodesWithFiles: Bool?
    let ignoreEpisodesWithoutFiles: Bool?
    let monitor: String?
    let searchForMissingEpisodes: Bool?
    let searchForCutoffUnmetEpisodes: Bool?
}

struct AddShow: Codable {
    let tvdbId: Int
    let title: String
    let qualityProfileId: Int
    let titleSlug: String
    let images: [Cover]
    let seasons: [Season]
    let languageProfileId: Int
    let path: String
    let monitored: Bool
}
