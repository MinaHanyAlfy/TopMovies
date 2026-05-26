//
//  FetchMovieDetailsUseCase.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-25.
//

import Foundation

protocol FetchMovieDetailsUseCaseProtocol {
    func execute(movieId: Int) async throws -> MovieDetailsEntity
}

final class FetchMovieDetailsUseCase: FetchMovieDetailsUseCaseProtocol {
    private let repository: MoviesRepository

    init(
        repository: MoviesRepository
    ) {
        self.repository = repository
    }

    func execute(
        movieId: Int
    ) async throws -> MovieDetailsEntity {
        
        try await repository
            .fetchMovieDetails(
                movieId: movieId
            )
    }
}
