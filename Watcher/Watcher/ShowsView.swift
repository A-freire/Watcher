//
//  ShowsView.swift
//  Watcher
//
//  Created by Adrien Freire on 18/12/2024.
//

import SwiftUI
import Kingfisher

struct ShowsView: View {
    @ObservedObject var gsManager = GridSizeManager(userDefaultsKey: "ShowsGrid")
    @ObservedObject var vm: ShowsVM

    init(serviceConfig: ServiceConfig) {
        self.vm = ShowsVM(sonarr: serviceConfig)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                if !vm.shows.isEmpty {
                    LazyVGrid(columns: gsManager.selectedSize.gridItems) {
                        ForEach(vm.searchedShows, id: \.self) { show in
                            ShowCardView(vm: vm.initShowVM(show: show), status: vm.getShowStatus(id: show.id))
                        }
                    }
                } else {
                    ProgressView()
                }
            }
            .onAppear(perform: {
                vm.fetchInit()
                vm.getSizeLeft()
            })
            .refreshable(action: {
                vm.fetchInit()
            })
            .searchable(text: $vm.search, prompt: "Search")
            .toolbar {
                //TODO: eraseMode
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "trash")
                        .foregroundStyle(vm.eraseMode ? .red : .white)
                        .onTapGesture {
                            vm.eraseMode.toggle()
                        }
                }
                if UIDevice.current.userInterfaceIdiom == .pad {
                    ToolbarItem(placement: .topBarTrailing) {
                        Image(systemName: gsManager.selectedSize.gridImage)
                            .onTapGesture {
                                gsManager.changeColumns()
                            }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Text("\(vm.spaceLeft) GB left")
                        .onTapGesture {
                            vm.getSizeLeft()
                        }
                }
            }
        }
    }
}


struct ShowCardView: View {
    @ObservedObject var vm: ShowVM
    let status: Status
    @State var isPresented: Bool = false

    var body: some View {
        VStack {
            KFImage(vm.show.getPoster)
                .resizable()
                .scaledToFit()
                .overlay(alignment: .bottomTrailing) {
                    DotStatus(color: status.color)
                        .padding(2)
                }
        }
        .onTapGesture {
            withAnimation {
                isPresented.toggle()
            }
        }
        .sheet(isPresented: $isPresented) {
            ShowSheetView(vm: vm, status: status)
        }
    }
}

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
//            List(show.getSeasons, children: \.episode) { row in
//                ShowEpSeasonView(index: i)
//            }
            List(vm.show.getSeasons, id: \.self) { season in
                ShowEpSeasonView(season: season) { sID in
                    vm.monitorSeason(sID: sID)
                }
            }
            .listStyle(.grouped)
            .scrollIndicators(.hidden)
        }
        .task {
            await vm.fetchShow()
        }
    }
}

struct ShowEpSeasonView: View {
    var season: Season
    var onMonitoring: (Int) -> Void
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
                        onMonitoring(season.getSeasonNumber)
                    }
                Image(systemName: "trash")
                Image(systemName: showEp ? "chevron.up" : "chevron.down")
            }
            .onTapGesture {
                showEp.toggle()
            }
            if showEp {
                withAnimation(.easeInOut) {
                    ForEach(0..<10) {
                        Text("\($0)")
                    }
                }
            }
        }
    }
}
