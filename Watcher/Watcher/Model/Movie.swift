//
//  Movie.swift
//  Watcher
//
//  Created by Adrien Freire on 23/12/2024.
//

import Foundation

// MARK: - Movie
struct Movie: Codable, Equatable, Hashable {
    let id: Int
    let title: String?
    let originalTitle: String?
    let alternateTitles: [AlternateTitle]
    let secondaryYear: Int?
    let secondaryYearSourceId: Int?
    let sortTitle: String?
    let sizeOnDisk: Int?
    let status: String?
    let overview: String?
    let inCinemas: String?
    let physicalRelease: String?
    let digitalRelease: String?
    let images: [Cover]
    let website: String?
    let year: Int?
    let hasFile: Bool?
    let youTubeTrailerId: String?
    let studio: String?
    let path: String?
    let qualityProfileId: Int?
    let monitored: Bool?
    let minimumAvailability: String?
    let isAvailable: Bool?
    let folderName: String?
    let runtime: Int?
    let cleanTitle: String?
    let imdbId: String?
    let tmdbId: Int?
    let titleSlug: String?
    let certification: String?
    let genres: [String]
    let tags: [String]
    let added: String?
    let ratings: Ratings?
    let movieFile: MovieFile?
    let collection: Collection?
}

// MARK: - AlternateTitle
struct AlternateTitle: Codable, Equatable, Hashable {
    let sourceType: String?
    let movieId: Int?
    let title: String?
    let sourceId: Int?
    let votes: Int?
    let voteCount: Int?
    let language: Language?
    let id: Int?
}

// MARK: - Language
struct Language: Codable, Equatable, Hashable {
    let id: Int?
    let name: String?
}

// MARK: - Cover
struct Cover: Codable, Equatable, Hashable {
    let coverType: String?
    let url: String?
    let remoteUrl: String?
}

// MARK: - Ratings
struct Ratings: Codable, Equatable, Hashable {
    let votes: Int?
    let value: Double?
}

// MARK: - MovieFile
struct MovieFile: Codable, Equatable, Hashable {
    let movieId: Int?
    let relativePath: String?
    let path: String?
    let size: Int?
    let dateAdded: String?
    let sceneName: String?
    let indexerFlags: Int?
    let quality: Quality?
    let mediaInfo: MediaInfo?
    let originalFilePath: String?
    let qualityCutoffNotMet: Bool?
    let languages: [Language]
    let releaseGroup: String?
    let edition: String?
    let id: Int?
}

// MARK: - Quality
struct Quality: Codable, Equatable, Hashable {
    let quality: QualityDetail?
    let revision: Revision?
}

// MARK: - QualityDetail
struct QualityDetail: Codable, Equatable, Hashable {
    let id: Int?
    let name: String?
    let source: String?
    let resolution: Int?
    let modifier: String?
}

// MARK: - Revision
struct Revision: Codable, Equatable, Hashable {
    let version: Int?
    let real: Int?
    let isRepack: Bool?
}

// MARK: - MediaInfo
struct MediaInfo: Codable, Equatable, Hashable {
    let audioAdditionalFeatures: String?
    let audioBitrate: Int?
    let audioChannels: Double?
    let audioCodec: String?
    let audioLanguages: String?
    let audioStreamCount: Int?
    let videoBitDepth: Int?
    let videoBitrate: Int?
    let videoCodec: String?
    let videoFps: Double?
    let resolution: String?
    let runTime: String?
    let scanType: String?
    let subtitles: String?
}

// MARK: - Collection
struct Collection: Codable, Equatable, Hashable {
    let name: String?
    let tmdbId: Int?
    let images: [Cover]
}


