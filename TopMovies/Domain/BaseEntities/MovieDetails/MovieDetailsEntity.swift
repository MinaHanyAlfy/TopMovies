//
//  MovieDetailsEntity.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-24.
//

// MARK: - MovieDetails
struct MovieDetailsEntity {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let runtime: Int
    let genres: [String]
    let voteAverage: Double
    let tagline: String?
}
