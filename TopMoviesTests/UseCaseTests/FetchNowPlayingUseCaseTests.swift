//
//  FetchNowPlayingUseCaseTests.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-26.
//

import XCTest
@testable import TopMovies

final class FetchNowPlayingUseCaseTests: XCTestCase {
    func test_execute_returnsMovies() async throws {
        let repository =
            MockMoviesRepository()

        repository.movies = [
            MovieEntity(
                id: 550,
                adult: false,
                originalTitle:
                    "Fight Club",
                posterPath:
                    "/poster.jpg",
                releaseDate:
                    "1999",
                title:
                    "Fight Club"
            )
        ]

        let useCase =
            FetchPopularMoviesUseCase(
                repository:
                    repository
            )

        let result =
            try await useCase
                .execute(
                    page: 1
                )

        XCTAssertEqual(
            result.count,
            1
        )

        XCTAssertEqual(
            result.first?.title,
            "Fight Club"
        )
    }
}
