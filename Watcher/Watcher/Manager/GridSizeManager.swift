//
//  GridSizeManager.swift
//  Watcher
//
//  Created by Adrien Freire on 17/12/2024.
//

import Foundation
import SwiftUI

class GridSizeManager: ObservableObject {
    @Published var selectedSize: Size {
        didSet {
            saveSizeToUserDefaults()
        }
    }

    private var userDefaultsKey: String

    init(userDefaultsKey: String) {
        self.userDefaultsKey = userDefaultsKey
        if let savedSize = UserDefaults.standard.string(forKey: userDefaultsKey),
           let size = Size(rawValue: savedSize) {
            self.selectedSize = size
        } else {
            self.selectedSize = .small
        }
    }

    func changeColumns() {
        self.selectedSize = selectedSize.next
    }

    private func saveSizeToUserDefaults() {
        UserDefaults.standard.set(selectedSize.rawValue, forKey: userDefaultsKey)
    }
}

enum Size: String, CaseIterable {
    case small
    case medium
    case big

    var next: Size {
        switch self {
        case .small: return .medium
        case .medium: return .big
        case .big: return .small
        }
    }

    var gridItems: [GridItem] {
        switch self {
        case .small:
            return Array(repeating: GridItem(.flexible()), count: 3)
        case .medium:
            return Array(repeating: GridItem(.flexible()), count: 6)
        case .big:
            return Array(repeating: GridItem(.flexible()), count: 9)
        }
    }

    var gridImage: String {
        switch self {
        case .small:
            return "square.grid.2x2.fill"
        case .medium:
            return "square.grid.3x3.fill"
        case .big:
            return "square.grid.4x3.fill"
        }
    }
}
