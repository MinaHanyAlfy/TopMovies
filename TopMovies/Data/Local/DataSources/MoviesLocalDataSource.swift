//
//  MoviesLocalDataSource.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-27.
//

import Foundation

protocol MoviesLocalDataSource {
    func save(movies: [MovieEntity], category: MovieCategory) throws
    func fetch(category: MovieCategory) throws -> [MovieEntity]
    func saveMovieDetails(_ details: MovieDetailsEntity) throws
    func fetchMovieDetails(movieId: Int) throws -> MovieDetailsEntity?
}
