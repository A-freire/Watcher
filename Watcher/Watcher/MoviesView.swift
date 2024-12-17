//
//  MoviesView.swift
//  Watcher
//
//  Created by Adrien Freire on 16/12/2024.
//

import SwiftUI

struct MoviesView: View {
    let mashaArray = Array(repeating: "Masha", count: 100)
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    @State var search: String = ""
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(mashaArray.indices, id: \.self) { index in
                        MovieCardView(name: mashaArray[index])
                    }
                }
            }
            .searchable(text: $search, prompt: "Search")
            .toolbar {
                
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
            isPresented.toggle()
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
                        LinearGradient(colors: [.black, .clear], startPoint: .bottom, endPoint: .center)
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
                Spacer()
            }
            .padding(.horizontal)
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
