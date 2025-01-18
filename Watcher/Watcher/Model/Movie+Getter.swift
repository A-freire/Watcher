//
//  Movie+Getter.swift
//  Watcher
//
//  Created by Adrien Freire on 23/12/2024.
//

import Foundation

extension Movie {
    var getTitle: String { title ?? "Unknown Title" }
    var getOriginalTitle: String { originalTitle ?? "Unknown Original Title" }
    var getAlternateTitles: [AlternateTitle] { alternateTitles }
    var getSecondaryYear: Int { secondaryYear ?? 0 }
    var getSecondaryYearSourceId: Int { secondaryYearSourceId ?? 0 }
    var getSortTitle: String { sortTitle ?? "Unknown Sort Title" }
    var getSizeOnDisk: Int { sizeOnDisk ?? 0 }
    var getStatus: String { status ?? "Unknown Status" }
    var getOverview: String { overview ?? "N/A" }
    var getInCinemas: String { inCinemas ?? "N/A" }
    var getPhysicalRelease: String { physicalRelease ?? "N/A" }
    var getDigitalRelease: String { digitalRelease ?? "N/A" }
    var getImages: [Cover] { images }
    var getWebsite: String { website ?? "Unknown Website" }
    var getYear: Int { year ?? 0 }
    var getHasFile: Bool { hasFile ?? false }
    var getYouTubeTrailerId: String { youTubeTrailerId ?? "No Trailer ID" }
    var getStudio: String { studio ?? "Unknown Studio" }
    var getPath: String { path ?? "Unknown Path" }
    var getQualityProfileId: Int { qualityProfileId ?? 1 }
    var getMonitored: Bool { monitored ?? false }
    var getMinimumAvailability: String { minimumAvailability ?? "Unknown" }
    var getIsAvailable: Bool { isAvailable ?? false }
    var getFolderName: String { folderName ?? "Unknown Folder Name" }
    var getRuntime: Int { runtime ?? 0 }
    var getCleanTitle: String { cleanTitle ?? "Unknown Clean Title" }
    var getImdbId: String { imdbId ?? "Unknown IMDb ID" }
    var getTmdbId: Int { tmdbId ?? 0 }
    var getTitleSlug: String { titleSlug ?? "Unknown Title Slug" }
    var getCertification: String { certification ?? "Unknown Certification" }
    var getGenres: [String] { genres }
    var getTags: [String] { tags }
    var getAdded: String { added ?? "Unknown Date" }
    var getRatings: Ratings { ratings ?? Ratings(votes: 0, value: 0.0) }
    var getMovieFile: MovieFile { movieFile ?? MovieFile.default }
    var getCollection: Collection { collection ?? Collection.default }
    var getId: Int { id ?? 0 }
}

// MARK: - AlternateTitle
extension AlternateTitle {
    var getSourceType: String { sourceType ?? "Unknown Source Type" }
    var getMovieId: Int { movieId ?? 0 }
    var getTitle: String { title ?? "Unknown Title" }
    var getSourceId: Int { sourceId ?? 0 }
    var getVotes: Int { votes ?? 0 }
    var getVoteCount: Int { voteCount ?? 0 }
    var getLanguage: Language { language ?? Language.default }
    var getId: Int { id ?? 0 }
}

// MARK: - Language
extension Language {
    var getId: Int { id ?? 0 }
    var getName: String { name ?? "Unknown Language" }
    
    static var `default`: Language {
        return Language(id: 0, name: "Unknown Language")
    }
}

// MARK: - Cover
extension Cover {
    var getCoverType: String { coverType ?? "Unknown Cover Type" }
    var getUrl: URL { URL(string: url ?? "Unknown URL")! }
    var getRemoteUrl: URL { URL(string: remoteUrl ?? "Unknown Remote URL")! }
}

// MARK: - Ratings
extension Ratings {
    var getVotes: Int { votes ?? 0 }
    var getValue: Double { value ?? 0.0 }
}

// MARK: - MovieFile
extension MovieFile {
    var getMovieId: Int { movieId ?? 0 }
    var getRelativePath: String { relativePath ?? "Unknown Path" }
    var getPath: String { path ?? "Unknown Path" }
    var getSize: Int { size ?? 0 }
    var getDateAdded: String { dateAdded ?? "Unknown Date" }
    var getSceneName: String { sceneName ?? "Unknown Scene Name" }
    var getIndexerFlags: Int { indexerFlags ?? 0 }
    var getQuality: Quality { quality ?? Quality.default }
    var getMediaInfo: MediaInfo { mediaInfo ?? MediaInfo.default }
    var getOriginalFilePath: String { originalFilePath ?? "Unknown Path" }
    var getQualityCutoffNotMet: Bool { qualityCutoffNotMet ?? false }
    var getLanguages: [Language] { languages }
    var getReleaseGroup: String { releaseGroup ?? "Unknown Release Group" }
    var getEdition: String { edition ?? "" }
    var getId: Int { id ?? 0 }

    static var `default`: MovieFile {
        return MovieFile(
            movieId: 0,
            relativePath: "Unknown Path",
            path: "Unknown Path",
            size: 0,
            dateAdded: "Unknown Date",
            sceneName: "Unknown Scene",
            indexerFlags: 0,
            quality: Quality.default,
            mediaInfo: MediaInfo.default,
            originalFilePath: "Unknown Path",
            qualityCutoffNotMet: false,
            languages: [],
            releaseGroup: "Unknown Group",
            edition: "",
            id: 0
        )
    }
}

// MARK: - Quality
extension Quality {
    var getQuality: QualityDetail { quality ?? QualityDetail.default }
    var getRevision: Revision { revision ?? Revision.default }
    
    static var `default`: Quality {
        return Quality(quality: QualityDetail.default, revision: Revision.default)
    }
}

// MARK: - QualityDetail
extension QualityDetail {
    var getId: Int { id ?? 0 }
    var getName: String { name ?? "Unknown Quality" }
    var getSource: String { source ?? "Unknown Source" }
    var getResolution: Int { resolution ?? 0 }
    var getModifier: String { modifier ?? "None" }
    
    static var `default`: QualityDetail {
        return QualityDetail(id: 0, name: "Unknown Quality", source: "Unknown Source", resolution: 0, modifier: "None")
    }
}

// MARK: - Revision
extension Revision {
    var getVersion: Int { version ?? 0 }
    var getReal: Int { real ?? 0 }
    var getIsRepack: Bool { isRepack ?? false }
    
    static var `default`: Revision {
        return Revision(version: 0, real: 0, isRepack: false)
    }
}

// MARK: - MediaInfo
extension MediaInfo {
    var getAudioAdditionalFeatures: String { audioAdditionalFeatures ?? "None" }
    var getAudioBitrate: Int { audioBitrate ?? 0 }
    var getAudioChannels: Double { audioChannels ?? 0.0 }
    var getAudioCodec: String { audioCodec ?? "Unknown Codec" }
    var getAudioLanguages: String { audioLanguages ?? "Unknown Language" }
    var getAudioStreamCount: Int { audioStreamCount ?? 0 }
    var getVideoBitDepth: Int { videoBitDepth ?? 0 }
    var getVideoBitrate: Int { videoBitrate ?? 0 }
    var getVideoCodec: String { videoCodec ?? "Unknown Codec" }
    var getVideoFps: Double { videoFps ?? 0.0 }
    var getResolution: String { resolution ?? "Unknown Resolution" }
    var getRunTime: String { runTime ?? "0:00:00" }
    var getScanType: String { scanType ?? "Unknown" }
    var getSubtitles: String { subtitles ?? "None" }
    
    static var `default`: MediaInfo {
        return MediaInfo(
            audioAdditionalFeatures: "None",
            audioBitrate: 0,
            audioChannels: 0.0,
            audioCodec: "Unknown Codec",
            audioLanguages: "Unknown Language",
            audioStreamCount: 0,
            videoBitDepth: 0,
            videoBitrate: 0,
            videoCodec: "Unknown Codec",
            videoFps: 0.0,
            resolution: "Unknown Resolution",
            runTime: "0:00:00",
            scanType: "Unknown",
            subtitles: "None"
        )
    }
}

// MARK: - Collection
extension Collection {
    var getName: String { name ?? "Unknown Collection" }
    var getTmdbId: Int { tmdbId ?? 0 }
    var getImages: [Cover] { images }

    static var `default`: Collection {
        return Collection(
            name: "Unknown Collection",
            tmdbId: 0,
            images: []
        )
    }
}

// MARK: - Global
extension Movie {
    var getPoster: URL {
        let tmp = getImages.filter { $0.coverType == "poster" }
        return tmp.first?.getRemoteUrl ?? URL(string: "https://www.cinemademinuit.fr/public/upload/movie/000/poster.jpg")!

    }
    var getFanArt: URL {
        let tmp = getImages.filter { $0.coverType == "fanart" }
        return tmp.first?.getRemoteUrl ?? URL(string: "https://www.cinemademinuit.fr/public/upload/movie/000/poster.jpg")!
    }
    var getDuree: String {
        "Duree: \(getRuntime / 60)h\(getRuntime % 60)"
    }
    var getStringGenre: String {
        "Genres: " + getGenres.joined(separator: ", ")
    }
    var gotReleased: Bool {
        !(getInCinemas == "N/A" && getPhysicalRelease == "N/A" && getDigitalRelease == "N/A" && getOverview == "N/A")
    }
    var getNewPath: String {
        "/movies/\(getOriginalTitle) (\(getYear)) Default"
    }
    
    func copyToAdd() -> Movie {
        return Movie(
            id: self.getId,
            title: self.title,
            originalTitle: self.originalTitle,
            alternateTitles: self.alternateTitles,
            secondaryYear: self.secondaryYear,
            secondaryYearSourceId: self.secondaryYearSourceId,
            sortTitle: self.sortTitle,
            sizeOnDisk: self.sizeOnDisk,
            status: self.status,
            overview: self.overview,
            inCinemas: self.inCinemas,
            physicalRelease: self.physicalRelease,
            digitalRelease: self.digitalRelease,
            images: self.images,
            website: self.website,
            year: self.year,
            hasFile: self.hasFile,
            youTubeTrailerId: self.youTubeTrailerId,
            studio: self.studio,
            path: getNewPath,
            qualityProfileId: 1,
            monitored: true,
            minimumAvailability: self.minimumAvailability,
            isAvailable: self.isAvailable,
            folderName: self.folderName,
            runtime: self.runtime,
            cleanTitle: self.cleanTitle,
            imdbId: self.imdbId,
            tmdbId: self.tmdbId,
            titleSlug: self.titleSlug,
            certification: self.certification,
            genres: self.genres,
            tags: self.tags,
            added: self.added,
            ratings: self.ratings,
            movieFile: self.movieFile,
            collection: self.collection
        )
    }
}
