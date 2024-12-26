//
//  Queue.swift
//  Watcher
//
//  Created by Adrien Freire on 26/12/2024.
//

import Foundation

struct Queue: Codable {
    let page: Int
    let pageSize: Int
    let sortKey: String?
    let sortDirection: String //[ default, ascending, descending ]
    let totalRecords: Int
    let records: [Record]?
}

struct Record: Codable {
  let movieId: Int?
}

extension Queue {
    var getPage: Int { page }
    var getPageSize: Int { pageSize }
    var getSortKey: String { sortKey ?? "timeleft" }
    var getSortDirection: String { sortDirection }
    var getTotalRecords: Int { totalRecords }
    var getRecords: [Record] { records ?? [] }
}

extension Record {
    var getMovieId: Int { movieId ?? 0 }
}
