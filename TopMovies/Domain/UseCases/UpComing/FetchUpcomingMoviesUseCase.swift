//
//  FetchUpcomingMoviesUseCase.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-25.
//

import Foundation

protocol FetchUpcomingMoviesUseCaseProtocol {
    func execute(page: Int) async throws -> [MovieEntity]
}

final class FetchUpcomingMoviesUseCase: FetchUpcomingMoviesUseCaseProtocol {
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
            .fetchUpcoming(
                page: page
            )
    }
}
