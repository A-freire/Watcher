//
//  Status.swift
//  Watcher
//
//  Created by Adrien Freire on 26/12/2024.
//

import Foundation
import SwiftUI

enum Status {
    case unavailable
    case queued
    case missing
    case downloaded
    case airing

    var name: String {
        switch self {
        case .unavailable:
            "Unavailable"
        case .queued:
            "Queued"
        case .missing:
            "Missing"
        case .downloaded:
            "Downloaded"
        case .airing:
            "Airing"
        }
    }

    var color: Color {
        switch self {
        case .unavailable:
            .white
        case .queued:
            .purple
        case .missing:
            .yellow
        case .downloaded:
            .green
        case .airing:
            .blue
        }
    }
}
