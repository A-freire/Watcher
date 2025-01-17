//
//  SearchView.swift
//  Watcher
//
//  Created by Adrien Freire on 18/12/2024.
//

import SwiftUI
import Kingfisher

struct SearchView: View {
    @ObservedObject var gsm = GridSizeManager(userDefaultsKey: "SearchGrid")
    @ObservedObject var vm: SearchVM

    init(radarr: ServiceConfig, sonarr: ServiceConfig) {
        self.vm = SearchVM(radarr: radarr, sonarr: sonarr)
    }

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Name of a movie or a tv-show", text: $vm.search)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .padding()
                ScrollView {
                    LazyVGrid(columns: gsm.selectedSize.gridItems) {
                        switch vm.data {
                        case .movies(let movies):
                            ForEach(movies , id: \.self) { movie in
                                SearchCardView(data: .movie(movie))
                            }
                        case .shows(let shows):
                            ForEach(shows , id: \.self) { show in
                                SearchCardView(data: .show(show))
                            }
                        default:
                            EmptyView()
                        }
                        
                    }
                }
                .scrollDismissesKeyboard(.immediately)
            }
            .toolbar {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    ToolbarItem(placement: .topBarTrailing) {
                        Image(systemName: gsm.selectedSize.gridImage)
                            .onTapGesture {
                                gsm.changeColumns()
                            }
                            .padding(.horizontal)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    SearchModeView(state: $vm.state)
                        .simultaneousGesture(TapGesture().onEnded({ _ in
                            vm.search = vm.search
                        }))
                }
            }
        }
        
    }
}

struct SearchModeView: View {
    @Binding var state: Bool
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.blue.opacity(0.2))
                .frame(width: 84, height: 44) // Taille du bouton
                .offset(x: state ? -37 : 42) // Position dynamique
                .animation(.easeInOut(duration: 0.3), value: state)
            HStack(spacing: 20){
                Button(action: {
                    withAnimation {
                        state.toggle()
                    }
                }, label: {
                    Text("Shows")
                        .foregroundStyle(state ? .blue : .gray.opacity(0.2))
                })
                Button(action: {
                    withAnimation {
                        state.toggle()
                    }
                }, label: {
                    Text("Movies")
                        .foregroundStyle(!state ? .blue : .gray.opacity(0.2))
                })
            }
        }
    }
}

struct SearchCardView: View {
    let data: SearchParam
    @State var isPresented: Bool = false

    var body: some View {
        VStack {
            switch data {
            case .movie(let movie):
                KFImage(movie.getPoster)
                    .resizable()
                    .scaledToFit()
                Spacer()
                Text(movie.getTitle)
                    .lineLimit(1)
            case .show(let show):
                KFImage(show.getPoster)
                    .resizable()
                    .scaledToFit()
                Spacer()
                Text(show.getTitle)
                    .lineLimit(1)
            default:
                EmptyView()
            }
        }
        .onTapGesture {
            isPresented.toggle()
        }
    }
}

enum SearchParam {
    case movie(Movie)
    case movies([Movie])
    case shows([Show])
    case show(Show)
}

