//
//  MoviesView.swift
//  Watcher
//
//  Created by Adrien Freire on 16/12/2024.
//

import SwiftUI

struct MoviesView: View {
    let mashaArray = Array(repeating: "Masha", count: 100)
    @ObservedObject var gsManager = GridSizeManager(userDefaultsKey: "MoviesGrid")
    @State var search: String = ""
    @State var eraseMode: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: gsManager.selectedSize.gridItems) {
                    ForEach(mashaArray.indices, id: \.self) { index in
                        MovieCardView(name: mashaArray[index])
                    }
                }
            }
            .searchable(text: $search, prompt: "Search")
            .toolbar {
                //TODO: eraseMode
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "trash")
                        .foregroundStyle(eraseMode ? .red : .white)
                        .onTapGesture {
                            eraseMode.toggle()
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
                    Text("2259 GB left")
                }
            }
        }
    }
}

struct MovieCardView: View {
    let name: String
    @State var isPresented: Bool = false

    var body: some View {
        VStack {
            Image(name)
                .resizable()
                .scaledToFit()
        }
        .onTapGesture {
            withAnimation {
                isPresented.toggle()
            }
        }
        .sheet(isPresented: $isPresented) {
            MovieSheetView()
        }
    }
}

struct MovieSheetView: View {
    
    var body: some View {
        VStack {
            Image("wild")
                .resizable()
                .scaledToFit()
                .overlay(alignment: .bottom) {
                    ZStack(alignment: .bottom) {
                        LinearGradient(colors: [.gray.opacity(0.2), .clear], startPoint: .bottom, endPoint: .center)
                        Text("American Pie presente : No limit !")
                            .font(.system(size: 42))
                    }
                }
            VStack(alignment:.leading, spacing: 12) {
                HStack {
                    Text("Duree: 1h42")
                    Spacer()
                    Text("Downloaded")
                    DotStatus()
                }
                Text("Genre:"+" Animation, Adventure, Comedy, Science Fiction, Action, Romance, Crime, Thriller")
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras suscipit felis est, sed volutpat dui viverra quis. Aliquam mollis nisl ante, eget ultrices diam convallis a. Nam lorem enim, laoreet id porttitor ut, pellentesque a velit. Sed sit amet ipsum tempus, luctus ante ut, scelerisque orci. Aliquam posuere nunc sagittis.")
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
