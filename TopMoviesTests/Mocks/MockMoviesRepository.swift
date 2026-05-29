//
//  MockMoviesRepository.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-26.
//

import Foundation
@testable import TopMovies

final class MockMoviesRepository: MoviesRepository {
    var movies: [MovieEntity] = []
    var movieDetails:
        MovieDetailsEntity?
    var shouldThrow = false

    func fetchNowPlaying(
        page: Int
    ) async throws -> [MovieEntity] {

        if shouldThrow {
            throw NetworkError.invalidUrl
        }

        return movies
    }

    func fetchPopular(
        page: Int
    ) async throws -> [MovieEntity] {

        if shouldThrow {
            throw NetworkError.invalidUrl
        }

        return movies
    }

    func fetchUpcoming(
        page: Int
    ) async throws -> [MovieEntity] {

        if shouldThrow {
            throw NetworkError.invalidUrl
        }

        return movies
    }

    func fetchMovieDetails(
        movieId: Int
    ) async throws
        -> MovieDetailsEntity {

        if shouldThrow {
            throw NetworkError.invalidUrl
        }

        guard let details =
            movieDetails
        else {

            fatalError(
                "Missing mock movieDetails"
            )
        }

        return details
    }
}
