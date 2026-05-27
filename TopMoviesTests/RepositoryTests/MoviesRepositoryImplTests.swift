//
//  MoviesRepositoryImplTests.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-24.
//

import XCTest
@testable import TopMovies

final class MoviesRepositoryImplTests: XCTestCase {
    private var network: MockNetworkClient!
    private var localClient: MockMoviesLocalDataSource!
    private var dataSource: MoviesRepositoryImpl!

    override func setUp() {
        network = MockNetworkClient()
        localClient = MockMoviesLocalDataSource()
        
        dataSource = MoviesRepositoryImpl(
            networkClient: network,
            localClient: localClient
        )
    }

    func test_fetchPopular_returnsRemoteMovies_andCachesThem() async throws {
        let dto = MovieDTO(
            adult: false,
            backdropPath: nil,
            genreIDS: nil,
            id: 550,
            originalTitle: nil,
            overview: nil,
            originalLanguage: nil,
            popularity: nil,
            posterPath: "/poster.jpg",
            releaseDate: "2025",
            title: "Fight Club",
            video: nil,
            voteAverage: nil,
            voteCount: nil
        )
        
        network.mockResponse = PageResponse<MovieDTO>(
            results: [dto],
            page: 1,
            totalPages: nil,
            totalResults: nil,
            dates: nil
        )
        
        let result = try await dataSource
            .fetchPopular(
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
        
        XCTAssertEqual(
            localClient.movies.count,
            1
        )
    }
    
    func test_fetchMovieDetails_returnsMappedMovieDetailsEntity() async throws {
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
            networkClient: mockClient,
            localClient: localClient
        )
        

        let result =
        try await repository
            .fetchMovieDetails(
                movieId: 550
            )

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
            result.genres,
            ["Action", "Adventure"]
        )
    }
    
    ///Test fetch popular movies when network fails.
    func test_fetchPopular_usesCache_whenRemoteFails() async throws {
        network.shouldThrowError = true

        localClient.movies = [
            MovieEntity(
                id: 1,
                adult: false,
                originalTitle: "Cached Movie",
                posterPath: "",
                releaseDate: "2022",
                title: "Cached Movie",
                category: .popular
            )
        ]

        let result = try await dataSource
            .fetchPopular(
                page: 1
            )

        XCTAssertEqual(
            result.count,
            1
        )

        XCTAssertEqual(
            result.first?.title,
            "Cached Movie"
        )
    }
    ///Test fetch Movie details when network fails.
    func test_fetchMovieDetails_usesCache_whenRemoteFails() async throws {  network.shouldThrowError = true

        localClient.movieDetails = MovieDetailsEntity(
            id: 550,
            title: "Cached Fight Club",
            overview: "Cached",
            runtime: 139,
            genres: ["Drama"],
            posterPath: "",
            releaseDate: "2022"
        )

        let result = try await dataSource
            .fetchMovieDetails(
                movieId: 550
            )

        XCTAssertEqual(
            result.title,
            "Cached Fight Club"
        )
    }
}
