//
//  MoviesLocalDataSourceTests.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-27.
//

import Foundation
import XCTest
import SwiftData
@testable import TopMovies

final class MoviesLocalDataSourceTests: XCTestCase {
    private var context: ModelContext!

    private var dataSource:
        MoviesLocalDataSourceImpl!

    override func setUpWithError()
    throws {

        let container =
            try MockModelContainer
                .make()

        context =
            ModelContext(
                container
            )

        dataSource =
            MoviesLocalDataSourceImpl(
                context:
                    context
            )
    }
}

extension MoviesLocalDataSourceTests {
    /// Test Saving Movies.
    func test_saveMovies_savesMovies() throws {
        let movies = [
            MovieEntity(
                id: 1,
                adult: false,
                originalTitle: "Batman",
                posterPath: "/batman.jpg",
                releaseDate: "2025",
                title: "Batman",
                category: .popular
            )
        ]
       

        try dataSource.save(
            movies: movies,
            category: .popular
        )

        let cached =
            try dataSource.fetch(
                category:
                    .popular
            )

        XCTAssertEqual(
            cached.count,
            1
        )

        XCTAssertEqual(
            cached.first?.title,
            "Batman"
        )
    }
    
    ///Test Category Speration.
    func test_fetch_returnsOnlyRequestedCategory() throws {
        let popularMovie = MovieEntity(
            id: 1,
            adult: false,
            originalTitle: "Batman",
            posterPath: "/batman.jpg",
            releaseDate: "2025",
            title: "Batman",
            category: .popular
        )
        
        let upcomingMovie = MovieEntity(
            id: 2,
            adult: false,
            originalTitle: "Superman",
            posterPath: "/jpg",
            releaseDate: "",
            title: "Superman",
            category: .upcoming
        )

        try dataSource.save(
            movies:
                [popularMovie],
            category:
                .popular
        )

        try dataSource.save(
            movies:
                [upcomingMovie],
            category:
                .upcoming
        )

        let popular =
            try dataSource.fetch(
                category:
                    .popular
            )

        XCTAssertEqual(
            popular.count,
            1
        )

        XCTAssertEqual(
            popular.first?.title,
            "Batman"
        )
    }
    
    /// Test replace existing category cached.
    func test_save_replacesExistingCategoryCache() throws {
        let oldMovie = MovieEntity(
            id: 1,
            adult: false,
            originalTitle: "OLD Superman",
            posterPath: "",
            releaseDate: "",
            title: "OLD",
            category: .popular
        )
        
        let newMovie = MovieEntity(
            id: 2,
            adult: true,
            originalTitle: "NEW Superman vs Batman",
            posterPath: "",
            releaseDate: "",
            title: "NEW",
            category: .popular
        )
        
        try dataSource.save(
            movies: [oldMovie],
            category: .popular
        )
        
        try dataSource.save(
            movies: [newMovie],
            category: .popular
        )
        
        let result = try dataSource.fetch(
            category: .popular
        )

        XCTAssertEqual(
            result.count,
            1
        )

        XCTAssertEqual(
            result.first?.title,
            "NEW"
        )
    }
    
    /// Test Movie Details.
    func test_saveMovieDetails_cachesDetails() throws {
        let details = MovieDetailsEntity(
            id: 550,
            title: "Fight Club",
            overview: "Overview",
            runtime: 139,
            genres: ["Drama"],
            posterPath: "/poster.jpg",
            releaseDate: "2025"
        )

        try dataSource.saveMovieDetails(details)

        let cached =
            try dataSource.fetchMovieDetails(movieId: 550)

        XCTAssertEqual(
            cached?.title,
            "Fight Club"
        )

        XCTAssertEqual(
            cached?.runtime,
            139
        )
    }
    
    ///Test Missing movie details.
    func test_fetchMovieDetails_returnsNilWhenMissing() throws {
        let result =
            try dataSource.fetchMovieDetails(movieId: 999)

        XCTAssertNil(
            result
        )
    }
}
