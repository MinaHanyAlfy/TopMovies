//
//  MoviesRepository.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-24.
//

import Foundation

protocol MoviesRepository {
    func fetchNowPlaying(page: Int) async throws -> [MovieEntity]
    func fetchPopular(page: Int) async throws -> [MovieEntity]
    func fetchUpcoming(page: Int) async throws -> [MovieEntity]
    func fetchMovieDetails(movieId: Int) async throws -> MovieDetailsEntity
}
