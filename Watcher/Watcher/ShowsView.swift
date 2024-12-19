//
//  ShowsView.swift
//  Watcher
//
//  Created by Adrien Freire on 18/12/2024.
//

import SwiftUI

struct ShowsView: View {
    let mashaArray = Array(repeating: "Masha", count: 100)
    @ObservedObject var gsManager = GridSizeManager()
    @State var search: String = ""
    @State var eraseMode: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: gsManager.selectedSize.gridItems) {
                    ForEach(mashaArray.indices, id: \.self) { index in
                        ShowCardView(name: mashaArray[index])
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


struct ShowCardView: View {
    let name: String
    @State var isPresented: Bool = false

    var body: some View {
        VStack {
            Image(name)
                .resizable()
                .scaledToFit()
                .rotationEffect(.degrees(180))
        }
        .onTapGesture {
            withAnimation {
                isPresented.toggle()
            }
        }
        .sheet(isPresented: $isPresented) {
            ShowSheetView()
        }
    }
}

struct ShowSheetView: View {
    @State private var isExpanded: Bool = false

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
                    .lineLimit(isExpanded ? nil : 2)
                    .animation(.default, value: isExpanded)
                    .onTapGesture {
                        isExpanded.toggle()
                    }
            }
            .padding(.horizontal)
//            List(<#T##data: Binding<MutableCollection & RandomAccessCollection>##Binding<MutableCollection & RandomAccessCollection>#>, children: <#T##WritableKeyPath<Identifiable, (MutableCollection & RandomAccessCollection)?>#>, rowContent: <#T##(Binding<Identifiable>) -> View#>)
//            List(data, id: \.self) { truc in
            List(0..<10) { i in
                ShowEpSeasonView(index: i)
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
        }
    }
}

struct ShowEpSeasonView: View {
    let index: Int
    @State var isBookmarked: Bool = false
    @State var showEp: Bool = false

    var body: some View {
        VStack {
            HStack {
                Text("Season \(index)")
                Text("13/13")
                Text("68.98 GB")
                Spacer()
                Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                    .onTapGesture {
                        isBookmarked.toggle()
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
