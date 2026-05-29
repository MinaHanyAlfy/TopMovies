//
//  FetchMovieDetailsUseCaseTests.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-26.
//

import XCTest
@testable import TopMovies

final class FetchMovieDetailsUseCaseTests: XCTestCase {
    func test_execute_returnsMovieDetails() async throws {
        let repository =
            MockMoviesRepository()

        repository.movieDetails =
            MovieDetailsEntity(
                id: 550,
                title: "Fight Club",
                overview:
                    "Some overview",
                runtime: 139,
                genres: ["Drama"],
                posterPath: "/poster.jpg",
                releaseDate: "1999"
            )

        let useCase =
            FetchMovieDetailsUseCase(
                repository:
                    repository
            )

        let result =
            try await useCase
                .execute(
                    movieId: 550
                )

        XCTAssertEqual(
            result.id,
            550
        )

        XCTAssertEqual(
            result.runtime,
            139
        )

        XCTAssertEqual(
            result.genres,
            ["Drama"]
        )
    }
}
