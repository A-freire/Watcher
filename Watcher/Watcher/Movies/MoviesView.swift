//
//  MoviesView.swift
//  Watcher
//
//  Created by Adrien Freire on 16/12/2024.
//

import SwiftUI
import Kingfisher

struct MoviesView: View {
    @ObservedObject var gsManager = GridSizeManager(userDefaultsKey: "MoviesGrid")
    @ObservedObject var vm: MoviesVM

    init(serviceConfig: ServiceConfig) {
        self.vm = MoviesVM(radarr: serviceConfig)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                if !vm.movies.isEmpty {
                    LazyVGrid(columns: gsManager.selectedSize.gridItems) {
                        ForEach(vm.searchedMovies, id: \.self) { movie in
                            MovieCardView(movie: movie, status: vm.getMovieStatus(id: movie.getId), eraseMode: $vm.eraseMode)
                                .simultaneousGesture(TapGesture().onEnded({ _ in
                                    vm.modifyDelete(id: movie.getId)
                                }), isEnabled: vm.eraseMode)
                                .border(vm.isSelected(id: movie.getId) ? .red : .clear, width: 10)
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
            .refreshable {
                vm.fetchInit()
            }
            .searchable(text: $vm.search, prompt: "Search")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "trash")
                        .foregroundStyle(vm.eraseMode ? .red : .white)
                        .onTapGesture {
                            vm.manageDelete()
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
            .alert("Confirm delete all selected movies ?", isPresented: $vm.confirmErase, actions: {
                Button("OK", role: .destructive) { vm.deleteAll() }
                Button("Cancel", role: .cancel) { vm.freeDelete() }
            })
        }
    }
}

struct MovieCardView: View {
    let movie: Movie
    let status: Status
    @Binding var eraseMode: Bool
    @State var isPresented: Bool = false

    var body: some View {
        VStack {
            KFImage(movie.getPoster)
                .resizable()
                .scaledToFit()
                .overlay(alignment: .bottomTrailing) {
                    DotStatus(color: status.color)
                        .padding(2)
                }
        }
        .onTapGesture {
            if !eraseMode {
                withAnimation {
                    isPresented.toggle()
                }
            }
        }
        .sheet(isPresented: $isPresented) {
            MovieSheetView(movie: movie, status: status)
        }
    }
}

struct MovieSheetView: View {
    let movie: Movie
    let status: Status

    var body: some View {
        VStack {
            KFImage(movie.getFanArt)
                .resizable()
                .scaledToFit()
                .overlay(alignment: .bottom) {
                    ZStack(alignment: .bottom) {
                        LinearGradient(colors: [Color.colorFromHex("1C1C1E"), .clear], startPoint: .bottom, endPoint: .center)
                        Text(movie.getTitle)
                            .font(.system(size: 33))
                            .padding(.horizontal)
                    }
                }
            VStack(alignment:.leading, spacing: 12) {
                HStack {
                    Text(movie.getDuree)
                    Spacer()
                    Text(status.name)
                    DotStatus(color: status.color)
                }
                Text(movie.getStringGenre)
                Text(movie.getOverview)
            }
            .padding(.horizontal)
            Spacer()
        }
    }
}

struct DotStatus: View {
    let color: Color
    var body: some View {
        Circle()
            .fill(color)
            .strokeBorder(.black, lineWidth: 3)
            .frame(width: 21, height: 21)
    }
}
