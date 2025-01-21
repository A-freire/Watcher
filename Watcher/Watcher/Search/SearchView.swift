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
    // swiftlint:disable:next identifier_name
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
                            ForEach(movies, id: \.self) { movie in
                                SearchCardView(data: .movie(movie)) { data in
                                    switch data {
                                    case .movie(let movie):
                                        vm.addMovie(movie: movie)
                                    default:
                                        break
                                    }
                                }
                            }
                        case .shows(let shows):
                            ForEach(shows, id: \.self) { show in
                                SearchCardView(data: .show(show)) { data in
                                    switch data {
                                    case .show(let show):
                                        vm.addShow(show: show)
                                    default:
                                        break
                                    }
                                }
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
            HStack(spacing: 20) {
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
    var onAdd: (SearchParam) -> Void

    var body: some View {
        VStack {
            switch data {
            case .movie(let movie):
                KFImage(movie.getPoster)
                    .resizable()
                    .overlay(content: {
                        if isPresented {
                            Color.black.opacity(0.5)
                            VStack {
                                Text(movie.getTitle)
                                    .font(.title3)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding([.top, .horizontal], 8)
                                Spacer()
                                HStack {
                                    Button {
                                        print("movie HD")
                                        onAdd(.movie(movie))
                                    } label: {
                                        Image(systemName: movie.getId != 0 ? "checkmark" : "plus")
                                            .padding()
                                            .background(.gray.opacity(0.2))
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                    }
                                    .background(.black)
                                    .cornerRadius(8)
                                    .disabled(movie.getId != 0)
                                    .padding(.bottom, 8)
                                }
                                .opacity(isPresented ? 1 : 0)
                                .offset(y: isPresented ? 0 : 20)
                                .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isPresented)
                            }
                        }
                    })
            case .show(let show):
                KFImage(show.getPoster)
                    .resizable()
                    .overlay {
                        if isPresented {
                            Color.black.opacity(0.5)
                            VStack {
                                Text(show.getTitle)
                                    .font(.title3)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding([.top, .horizontal], 8)
                                Spacer()
                                HStack {
                                    Button {
                                        print("show hd")
                                        onAdd(.show(show))
                                    } label: {
                                        Image(systemName: show.getId != 0 ? "checkmark" : "plus")
                                            .padding()
                                            .background(.gray.opacity(0.2))
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                    }
                                    .background(.black)
                                    .cornerRadius(8)
                                    .disabled(show.getId != 0)
                                    .padding(.bottom, 8)
                                }
                                .opacity(isPresented ? 1 : 0)
                                .offset(y: isPresented ? 0 : 20)
                                .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isPresented)
                            }
                        }
                    }
            default:
                EmptyView()
            }
        }
        .scaledToFit()
        .onTapGesture {
            withAnimation {
                isPresented.toggle()
            }
        }
    }
}

enum SearchParam {
    case movie(Movie)
    case movies([Movie])
    case shows([Show])
    case show(Show)
}
