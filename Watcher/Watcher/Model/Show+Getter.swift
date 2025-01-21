//
//  Show+Getter.swift
//  Watcher
//
//  Created by Adrien Freire on 29/12/2024.
//

import Foundation

extension Show {
    var getId: Int {
        id ?? 0
    }

    var getTitle: String {
        title ?? "Unknown Title"
    }

    var getAlternateTitles: [AlternateTitleShow] {
        alternateTitles ?? []
    }

    var getSortTitle: String {
        sortTitle ?? "Unknown Sort Title"
    }

    var getStatus: String {
        status ?? "Unknown Status"
    }

    var getEnded: Bool {
        ended ?? false
    }

    var getProfileName: String {
        profileName ?? "Unknown Profile Name"
    }

    var getOverview: String {
        overview ?? "N/A"
    }

    var getNextAiring: String {
        nextAiring ?? "No Next Airing"
    }

    var getPreviousAiring: String {
        previousAiring ?? "No Previous Airing"
    }

    var getNetwork: String {
        network ?? "Unknown Network"
    }

    var getAirTime: String {
        airTime ?? "Unknown Air Time"
    }

    var getImages: [Cover] {
        images
    }

    var getLanguageProfileId: Int {
        languageProfileId ?? 0
    }

    var getRemotePoster: String {
        remotePoster ?? "No Poster URL"
    }

    var getSeasons: [Season] {
        seasons.filter({ $0.getSeasonNumber != 0 })
    }

    var getYear: Int {
        year ?? 0
    }

    var getPath: String {
        path ?? "Unknown Path"
    }

    var getQualityProfileId: Int {
        qualityProfileId ?? 0
    }

    var getSeasonFolder: Bool {
        seasonFolder ?? false
    }

    var getMonitored: Bool {
        monitored ?? false
    }

    var getMonitorNewItems: String {
        monitorNewItems ?? "Default"
    }

    var getUseSceneNumbering: Bool {
        useSceneNumbering ?? false
    }

    var getRuntime: Int {
        runtime ?? 0
    }

    var getTvdbId: Int {
        tvdbId ?? 0
    }

    var getTvRageId: Int {
        tvRageId ?? 0
    }

    var getTvMazeId: Int {
        tvMazeId ?? 0
    }

    var getTmdbId: Int {
        tmdbId ?? 0
    }

    var getFirstAired: String {
        firstAired ?? "Unknown First Aired"
    }

    var getLastAired: String {
        lastAired ?? "Unknown Last Aired"
    }

    var getSeriesType: String {
        seriesType ?? "Unknown Series Type"
    }

    var getCleanTitle: String {
        cleanTitle ?? "Unknown Clean Title"
    }

    var getImdbId: String {
        imdbId ?? "Unknown IMDb ID"
    }

    var getTitleSlug: String {
        titleSlug ?? "Unknown Title Slug"
    }

    var getRootFolderPath: String {
        rootFolderPath ?? "Unknown Root Folder Path"
    }

    var getFolder: String {
        folder ?? "Unknown Folder"
    }

    var getCertification: String {
        certification ?? "Unknown Certification"
    }

    var getGenres: [String] {
        genres
    }

    var getTags: [Int] {
        tags
    }

    var getAdded: String {
        added ?? "Unknown Added Date"
    }

    var getAddOptions: AddOptions {
        addOptions ?? AddOptions.default
    }

    var getRatings: Ratings {
        ratings ?? Ratings(votes: 0, value: 0)
    }

    var getStatistics: Statistics {
        statistics ?? Statistics.default
    }

    var getEpisodesChanged: Bool {
        episodesChanged ?? false
    }

    static var `default`: Show {
        Show(
            id: 0,
            title: nil,
            alternateTitles: [],
            sortTitle: nil,
            status: nil,
            ended: false,
            profileName: nil,
            overview: nil,
            nextAiring: nil,
            previousAiring: nil,
            network: nil,
            airTime: nil,
            images: [],
            languageProfileId: nil,
            remotePoster: nil,
            seasons: [],
            year: nil,
            path: nil,
            qualityProfileId: nil,
            seasonFolder: false,
            monitored: false,
            monitorNewItems: nil,
            useSceneNumbering: false,
            runtime: nil,
            tvdbId: nil,
            tvRageId: nil,
            tvMazeId: nil,
            tmdbId: nil,
            firstAired: nil,
            lastAired: nil,
            seriesType: nil,
            cleanTitle: nil,
            imdbId: nil,
            titleSlug: nil,
            rootFolderPath: nil,
            folder: nil,
            certification: nil,
            genres: [],
            tags: [],
            added: nil,
            addOptions: nil,
            ratings: nil,
            statistics: nil,
            episodesChanged: false
        )
    }

    var getHasFiles: Bool {
        getStatistics.getHasFiles
    }

    var getIsAvailable: Bool {
        getStatistics.getEpisodeCount != 0
    }
}

extension AlternateTitleShow {
    var getTitle: String {
        title ?? "Unknown Title"
    }

    var getSeasonNumber: Int {
        seasonNumber ?? 0
    }

    var getSceneSeasonNumber: Int {
        sceneSeasonNumber ?? 0
    }

    var getSceneOrigin: String {
        sceneOrigin ?? "Unknown Scene Origin"
    }

    var getComment: String {
        comment ?? "No Comment"
    }

    static var `default`: AlternateTitleShow {
        AlternateTitleShow(
            title: nil,
            seasonNumber: nil,
            sceneSeasonNumber: nil,
            sceneOrigin: nil,
            comment: nil
        )
    }
}

extension Season {
    var getSeasonNumber: Int {
        seasonNumber ?? 0
    }

    var getMonitored: Bool {
        monitored ?? false
    }

    var getStatistics: Statistics {
        statistics ?? Statistics.default
    }

    var getImages: [Cover] {
        images ?? []
    }

    static var `default`: Season {
        Season(
            seasonNumber: nil,
            monitored: false,
            statistics: nil,
            images: []
        )
    }

    var getTotEp: String {
        self.getStatistics.getTotEp
    }

    var getSize: String {
        self.getStatistics.getSizeGB
    }
}

extension Statistics {
    var getSeasonCount: Int {
        seasonCount ?? 0
    }
    var getNextAiring: String {
        nextAiring ?? "No Next Airing"
    }
    var getPreviousAiring: String {
        previousAiring ?? "No Previous Airing"
    }
    var getEpisodeFileCount: Int {
        episodeFileCount ?? 0
    }
    var getEpisodeCount: Int {
        episodeCount ?? 0
    }
    var getTotalEpisodeCount: Int {
        totalEpisodeCount ?? 0
    }
    var getSizeOnDisk: Double {
        sizeOnDisk ?? 0
    }
    var getReleaseGroups: [String] {
        releaseGroups ?? []
    }
    var getPercentOfEpisodes: Double {
        percentOfEpisodes ?? 0
    }
    static var `default`: Statistics {
        Statistics(
            seasonCount: 0,
            nextAiring: nil,
            previousAiring: nil,
            episodeFileCount: 0,
            episodeCount: 0,
            totalEpisodeCount: 0,
            sizeOnDisk: 0,
            releaseGroups: [],
            percentOfEpisodes: 0
        )
    }
    var getTotEp: String {
        "\(getEpisodeFileCount) / \(getEpisodeCount)"
    }
    var getSizeGB: String {
        String(format: "%.2f", getSizeOnDisk * 0.000000001) + " GB"
    }
    var getHasFiles: Bool {
        getEpisodeFileCount == getEpisodeCount
    }
}

extension AddOptions {
    var getIgnoreEpisodesWithFiles: Bool {
        ignoreEpisodesWithFiles ?? false
    }
    var getIgnoreEpisodesWithoutFiles: Bool {
        ignoreEpisodesWithoutFiles ?? false
    }
    var getMonitor: String {
        monitor ?? "Default"
    }
    var getSearchForMissingEpisodes: Bool {
        searchForMissingEpisodes ?? false
    }
    var getSearchForCutoffUnmetEpisodes: Bool {
        searchForCutoffUnmetEpisodes ?? false
    }
    static var `default`: AddOptions {
        AddOptions(
            ignoreEpisodesWithFiles: false,
            ignoreEpisodesWithoutFiles: false,
            monitor: nil,
            searchForMissingEpisodes: false,
            searchForCutoffUnmetEpisodes: false
        )
    }
}
