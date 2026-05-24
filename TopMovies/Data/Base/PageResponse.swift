//
//  PageResponse.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-24.
//

import Foundation

// MARK: - PageResponse
struct PageResponse<T: Decodable>: Decodable {
    let results: [T]
    let page: Int
    let totalPages: Int?
    let totalResults: Int?
    let dates: Dates?
    
    enum CodingKeys: String, CodingKey {
          case dates, page, results
          case totalPages = "total_pages"
          case totalResults = "total_results"
      }
}

// MARK: - Dates
struct Dates: Decodable {
    let maximum, minimum: String
}
