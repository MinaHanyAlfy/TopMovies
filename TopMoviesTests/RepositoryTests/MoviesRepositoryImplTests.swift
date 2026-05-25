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
    
    func test_fetchMovieDetails_returnsMappedMovieDetailsEntity()
        async throws {

            // Arrange

            let mockClient = MockNetworkClient()

            mockClient.mockResponse =
                MovieDetailsDTO(
                    adult: false,
                    backdropPath: "/backdrop.jpg",
                    belongsToCollection: nil,
                    budget: 1000000,
                    genres: [
                        Genre(
                            id: 1,
                            name: "Action"
                        ),
                        Genre(
                            id: 2,
                            name: "Adventure"
                        )
                    ],
                    homepage: nil,
                    id: 550,
                    imdbID: nil,
                    originCountry: ["US"],
                    originalLanguage: "en",
                    originalTitle: "Fight Club",
                    overview: "Some overview",
                    popularity: 9.5,
                    posterPath: "/poster.jpg",
                    productionCompanies: nil,
                    productionCountries: nil,
                    releaseDate: "1999-10-15",
                    revenue: 5000000,
                    runtime: 139,
                    spokenLanguages: nil,
                    status: "Released",
                    tagline: "Mischief. Mayhem. Soap.",
                    title: "Fight Club",
                    video: false,
                    voteAverage: 8.4,
                    voteCount: 20000
                )

            let repository =
                MoviesRepositoryImpl(
                    networkClient: mockClient
                )

            // Act

            let result =
                try await repository
                    .fetchMovieDetails(
                        movieId: 550
                    )

            // Assert

            XCTAssertEqual(result.id, 550)
            XCTAssertEqual(result.title, "Fight Club")
            XCTAssertEqual(
                result.overview,
                "Some overview"
            )

            XCTAssertEqual(
                result.runtime,
                139
            )

            XCTAssertEqual(
                result.posterPath,
                "/poster.jpg"
            )

            XCTAssertEqual(
                result.voteAverage,
                8.4
            )

            XCTAssertEqual(
                result.genres,
                ["Action", "Adventure"]
            )
        }
}
