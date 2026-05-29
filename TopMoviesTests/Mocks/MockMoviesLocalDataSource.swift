//
//  MockMoviesLocalDataSource.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-27.
//
import Foundation
@testable import TopMovies

final class MockMoviesLocalDataSource: MoviesLocalDataSource {
    var movies: [MovieEntity] = []
    var movieDetails: MovieDetailsEntity?

    func save(
        movies: [MovieEntity],
        category: MovieCategory
    ) throws {
        self.movies = movies
    }

    func fetch(
        category: MovieCategory
    ) throws -> [MovieEntity] {
        return movies
    }

    func saveMovieDetails(
        _ details: MovieDetailsEntity
    ) throws {
        return movieDetails = details
    }

    func fetchMovieDetails(
        movieId: Int
    ) throws -> MovieDetailsEntity? {
        return movieDetails
    }
}
