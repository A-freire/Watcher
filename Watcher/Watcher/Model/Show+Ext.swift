//
//  Show+Ext.swift
//  Watcher
//
//  Created by Adrien Freire on 21/01/2025.
//

import Foundation

extension Show {
    var getPoster: URL {
        let tmp = getImages.filter { $0.coverType == "poster" }
        return tmp.first?.getRemoteUrl ?? URL(
            string:
                "https://www.cinemademinuit.fr/public/upload/movie/000/poster.jpg"
        )!
    }
    var getFanart: URL {
        let tmp = getImages.filter { $0.coverType == "fanart" }
        return tmp.first?.getRemoteUrl ?? URL(
            string:
                "https://www.cinemademinuit.fr/public/upload/movie/000/poster.jpg"
        )!
    }
    var getBanner: URL {
        let tmp = getImages.filter { $0.coverType == "banner" }
        return tmp.first?.getRemoteUrl ?? URL(
            string:
                "https://www.cinemademinuit.fr/public/upload/movie/000/poster.jpg"
        )!
    }
    var getUnknown: URL {
        let tmp = getImages.filter { $0.coverType == "unknown" }
        return tmp.first?.getRemoteUrl ?? URL(
            string:
                "https://www.cinemademinuit.fr/public/upload/movie/000/poster.jpg"
        )!
    }
    var getDuree: String {
        "Duree: \(getRuntime / 60)h\(getRuntime % 60)"
    }
    var getStringGenre: String {
        "Genres: " + getGenres.joined(separator: ", ")
    }
    var gotReleased: Bool {
        !(getOverview == "N/A")
    }
    func disableMonitoring(for seasons: [Season]) -> [Season] {
        return seasons.map { season in
            var newSeason = season
            newSeason.monitored = false
            return newSeason
        }
    }
    func copyToAdd() -> AddShow {
        return AddShow(
            tvdbId: getTvdbId,
            title: getTitle,
            qualityProfileId: 1,
            titleSlug: getTitleSlug,
            images: getImages,
            seasons: disableMonitoring(for: getSeasons),
            languageProfileId: 1,
            path: "/tvshow/\(getTitleSlug) {ImdbId}",
            monitored: true
        )
    }
}
