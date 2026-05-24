//
//  Movie.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-24.
//

import Foundation

// MARK: - Result
struct MovieEntity {
    var id: Int
    var adult: Bool?
    var originalTitle: String?
    var posterPath, releaseDate, title: String?
}

