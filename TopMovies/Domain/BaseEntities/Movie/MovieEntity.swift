//
//  Movie.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-24.
//

import Foundation
import SwiftData

@Model
final class MovieEntity: Equatable, Identifiable {

    @Attribute(.unique)
    var id: Int

    var adult: Bool
    var originalTitle: String
    var posterPath: String
    var releaseDate: String
    var title: String
    var categoryValue: String
       
    var category: MovieCategory {
        get { MovieCategory(rawValue: categoryValue) ?? .nowPlaying }
        set { categoryValue = newValue.rawValue }
    }
    init(
        id: Int,
        adult: Bool,
        originalTitle: String,
        posterPath: String,
        releaseDate: String,
        title: String,
        category: MovieCategory
    ) {
        self.id = id
        self.adult = adult
        self.originalTitle = originalTitle
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
        self.categoryValue = category.rawValue
    }
}

enum MovieCategory: String, Codable, CaseIterable {
    case nowPlaying = "Now Playing"
    case popular = "Popular"
    case upcoming = "Up Coming"
}
