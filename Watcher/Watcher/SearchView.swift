//
//  SearchView.swift
//  Watcher
//
//  Created by Adrien Freire on 18/12/2024.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var gsm = GridSizeManager(userDefaultsKey: "SearchGrid")

    @State var search: String = ""
    @State var state: Bool = true

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Name of a movie or a tv-show", text: $search)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .padding()
                ScrollView {
                    LazyVGrid(columns: gsm.selectedSize.gridItems) {
                        ForEach(0..<10) { _ in
                            SearchCardView(state: $state)
                        }
                    }
                }
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
                    SearchModeView(state: $state)
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
    @Binding var state: Bool
    var body: some View {
        VStack {
            Image("joker")
                .resizable()
                .scaledToFit()
            Text("American Pie presente : No limit !")
        }
    }
}
