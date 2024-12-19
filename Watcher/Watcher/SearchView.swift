//
//  SearchView.swift
//  Watcher
//
//  Created by Adrien Freire on 18/12/2024.
//

import SwiftUI

struct SearchView: View {
    @State var search: String = ""
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Name of a movie or a tv-show", text: $search)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .padding()
                List(0..<10, id: \.self) {_ in 
                    SearchCardView()
                }
                .listStyle(.plain)
                .listRowInsets(EdgeInsets())
                .scrollIndicators(.hidden)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    SearchModeView()
                }
            }
        }
        
    }
}

struct SearchModeView: View {
    @State var test: Bool = true
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.blue.opacity(0.2))
                .frame(width: 84, height: 44) // Taille du bouton
                .offset(x: test ? -37 : 42) // Position dynamique
                .animation(.easeInOut(duration: 0.3), value: test)
            HStack(spacing: 20){
                Button(action: {
                    withAnimation {
                        test.toggle()
                    }
                }, label: {
                    Text("Shows")
                        .foregroundStyle(test ? .blue : .gray.opacity(0.2))
                })
                Button(action: {
                    withAnimation {
                        test.toggle()
                    }
                }, label: {
                    Text("Movies")
                        .foregroundStyle(!test ? .blue : .gray.opacity(0.2))
                })
            }
        }
    }
}

struct SearchCardView: View {
    
    var body: some View {
        HStack {
            Image("Masha")
                .resizable()
                .scaledToFit()
            VStack {
                Text("American Pie presente : No limit !")
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras suscipit felis est, sed volutpat dui viverra quis. Aliquam mollis nisl ante, eget ultrices diam convallis a. Nam lorem enim, laoreet id porttitor ut, pellentesque a velit. Sed sit amet ipsum tempus, luctus ante ut, scelerisque orci. Aliquam posuere nunc sagittis.")
            }
        }
    }
}
