//
//  EraseMode.swift
//  Watcher
//
//  Created by Adrien Freire on 18/12/2024.
//

import Foundation
import SwiftUI

//TODO: eraseMode
struct MultiSelectionGridView: View {
    @State private var items: [Int] = Array(0..<30) // Tableau des éléments
    @State private var selectedItems: Set<Int> = [] // Indices des éléments sélectionnés
    @State private var isSelectionMode: Bool = false // Active/Désactive le mode multi-sélection

    private let columns = Array(repeating: GridItem(.flexible()), count: 4)

    var body: some View {
        VStack {
            // Bouton pour activer/désactiver le mode sélection
            HStack {
                Button(action: {
                    isSelectionMode.toggle()
                    selectedItems.removeAll() // Réinitialiser les sélections
                }) {
                    Text(isSelectionMode ? "Quitter Sélection" : "Mode Sélection")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                if isSelectionMode && !selectedItems.isEmpty {
                    Button(action: deleteSelectedItems) {
                        Text("Supprimer (\(selectedItems.count))")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .padding()

            // Grille avec les éléments
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(items, id: \.self) { item in
                        ZStack {
                            Rectangle()
                                .fill(selectedItems.contains(item) ? Color.red.opacity(0.5) : Color.blue.opacity(0.7))
                                .frame(height: 80)
                                .cornerRadius(8)
                                .onTapGesture {
                                    handleSelection(for: item)
                                }

                            Text("\(item)")
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                    }
                }
                .padding()
            }
        }
    }

    // Gère la sélection ou dé-sélection d'un élément
    private func handleSelection(for item: Int) {
        guard isSelectionMode else { return }

        if selectedItems.contains(item) {
            selectedItems.remove(item) // Dé-sélectionner
        } else {
            selectedItems.insert(item) // Sélectionner
        }
    }

    // Supprimer les éléments sélectionnés
    private func deleteSelectedItems() {
        items.removeAll { selectedItems.contains($0) }
        selectedItems.removeAll() // Réinitialiser les sélections
    }
}
