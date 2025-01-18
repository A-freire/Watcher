//
//  ShowView.swift
//  Watcher
//
//  Created by Adrien Freire on 08/01/2025.
//

import SwiftUI
import Kingfisher

struct ShowSheetView: View {
    @State private var isExpanded: Bool = false
    @ObservedObject var vm: ShowVM
    let status: Status

    var body: some View {
        VStack {
            KFImage(vm.show.getFanart)
                .resizable()
                .aspectRatio(contentMode: UIDevice.current.userInterfaceIdiom == .pad ? .fill : .fit)
                .overlay(alignment: .bottom) {
                    ZStack(alignment: .bottom) {
                        LinearGradient(colors: [.gray.opacity(0.2), .clear], startPoint: .bottom, endPoint: .center)
                        Text(vm.show.getTitle)
                            .font(.system(size: 33))
                    }
                }
            VStack(alignment:.leading, spacing: 12) {
                HStack {
                    Text(vm.show.getDuree)
                    Spacer()
                    Text(status.name)
                    DotStatus(color: status.color)
                }
                Text(vm.show.getStringGenre)
                Text(vm.show.getOverview)
                    .lineLimit(isExpanded ? nil : 2)
                    .animation(.default, value: isExpanded)
                    .onTapGesture {
                        isExpanded.toggle()
                    }
            }
            .padding(.horizontal)
            List(vm.show.getSeasons, id: \.self) { season in
                ShowEpSeasonView(season: season, episodes: vm.getEpSeason(number: season.getSeasonNumber)) { sID, delete  in
                    if delete {
                        vm.deleteSeason(seasonNumber: sID)
                    } else {
                        vm.monitorSeason(sID: sID)
                    }
                }
            }
            .listStyle(.grouped)
            .scrollIndicators(.hidden)
        }
        .task {
            await vm.fetchShow()
            await vm.fetchEpisodes()
        }
    }
}

struct ShowEpSeasonView: View {
    var season: Season
    var episodes: [Episode]
    var onGesture: (Int, Bool) -> Void
    @State var showEp: Bool = false

    var body: some View {
        VStack {
            HStack {
                Text("Season \(season.getSeasonNumber)")
                Text(season.getTotEp)
                Text(season.getSize)
                Spacer()
                Image(systemName: season.getMonitored ? "bookmark.fill" : "bookmark")
                    .onTapGesture {
                        onGesture(season.getSeasonNumber, false)
                    }
                Image(systemName: "trash")
                    .onTapGesture {
                        onGesture(season.getSeasonNumber, true)
                    }
                Image(systemName: showEp ? "chevron.up" : "chevron.down")
            }
            .contentShape(Rectangle())
            .onTapGesture {
                showEp.toggle()
            }
            if showEp {
                withAnimation(.easeInOut) {
                    ForEach(episodes, id: \.self) { ep in
                        EpisodeRow(ep: ep)
                    }
                }
            }
        }
    }
}

struct EpisodeRow: View {
    let ep: Episode

    var body: some View {
        HStack {
            Text("\(ep.getEpisodeNumber).")
                .monospacedDigit()
            Text(ep.getTitle)
            Spacer()
        }
    }
}
