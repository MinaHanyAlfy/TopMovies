//
//  FetchPopularMoviesUseCase.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-25.
//

import Foundation

protocol FetchPopularMoviesUseCaseProtocol {
    func execute(page: Int) async throws -> [MovieEntity]
}

final class FetchPopularMoviesUseCase: FetchPopularMoviesUseCaseProtocol {
    private let repository: MoviesRepository

    init(
        repository: MoviesRepository
    ) {
        self.repository = repository
    }

    func execute(
        page: Int
    ) async throws -> [MovieEntity] {

        try await repository
            .fetchPopular(
                page: page
            )
    }
}
