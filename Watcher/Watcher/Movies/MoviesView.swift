//
//  MoviesView.swift
//  Watcher
//
//  Created by Adrien Freire on 16/12/2024.
//

import SwiftUI
import Kingfisher

struct MoviesView: View {
    let mashaArray = Array(repeating: "Masha", count: 100)
    @ObservedObject var gsManager = GridSizeManager(userDefaultsKey: "MoviesGrid")
    @ObservedObject var vm: MoviesVM
    
    

    init(serviceConfig: ServiceConfig) {
        self.vm = MoviesVM(radarr: serviceConfig)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: gsManager.selectedSize.gridItems) {
                    ForEach(vm.movies, id: \.self) { movie in
                        MovieCardView(movie: movie)
                    }
                }
            }
            .onAppear(perform: {
                vm.fetchMovies()
                vm.getSizeLeft()
            })
            .refreshable {
                vm.fetchMovies()
            }
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

struct MovieCardView: View {
    let movie: Movie
    @State var isPresented: Bool = false

    var body: some View {
        VStack {
            KFImage(movie.getPoster)
                .resizable()
                .scaledToFit()
        }
        .onTapGesture {
            withAnimation {
                isPresented.toggle()
            }
        }
        .sheet(isPresented: $isPresented) {
            MovieSheetView(movie: movie)
        }
    }
}

struct MovieSheetView: View {
    let movie: Movie

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
                    Text("Downloaded")
                    DotStatus()
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

    var body: some View {
        Circle()
            .fill(.yellow)
            .strokeBorder(.black, lineWidth: 3)
            .frame(width: 21, height: 21)
    }
}
