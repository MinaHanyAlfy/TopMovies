//
//  MovieDetailsEntity.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-24.
//
import Foundation
import SwiftData

// MARK: - MovieDetails
@Model
final class MovieDetailsEntity {

    @Attribute(.unique)
    var id: Int

    var title: String
    var overview: String
    var runtime: Int
    var genres: [String]
    var posterPath: String
    var releaseDate: String
    init(
        id: Int,
        title: String,
        overview: String,
        runtime: Int,
        genres: [String],
        posterPath: String,
        releaseDate: String
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.runtime = runtime
        self.genres = genres
        self.posterPath = posterPath
        self.releaseDate = releaseDate
    }
}
