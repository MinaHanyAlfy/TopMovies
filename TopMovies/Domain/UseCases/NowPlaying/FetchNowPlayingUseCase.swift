//
//  FetchNowPlayingUseCase.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-25.
//

import Foundation

protocol FetchNowPlayingUseCaseProtocol {
    func execute(page: Int) async throws -> [MovieEntity]
}

final class FetchNowPlayingUseCase: FetchNowPlayingUseCaseProtocol {
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
            .fetchNowPlaying(
                page: page
            )
    }
}
