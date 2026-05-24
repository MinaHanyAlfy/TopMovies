//
//  MoviesRepositoryImplTests.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-24.
//

import XCTest
@testable import TopMovies

final class MoviesRepositoryImplTests: XCTestCase {

    func test_fetchPopular_returnsMappedMovies()
    async throws {

        let mockClient = MockNetworkClient()

        mockClient.mockResponse =
            PageResponse<MovieDTO>(
                results: [
                    MovieDTO(
                        adult: false,
                        backdropPath: nil,
                        genreIDS: nil,
                        id: 550,
                        originalTitle: nil,
                        overview: "Overview",
                        originalLanguage: nil,
                        popularity: nil,
                        posterPath: "/poster.jpg",
                        releaseDate: nil,
                        title: "Fight Club",
                        video: nil,
                        voteAverage: 8.4,
                        voteCount: nil
                    )
                ],
                page: 1,
                totalPages: 10,
                totalResults: 100,
                dates: nil
            )

        let repository =
            MoviesRepositoryImpl(
                networkClient: mockClient
            )

        let movies =
            try await repository
                .fetchPopular(page: 1)

        XCTAssertEqual(movies.count, 1)

        XCTAssertEqual(
            movies.first?.id,
            550
        )

        XCTAssertEqual(
            movies.first?.title,
            "Fight Club"
        )
    }
}
