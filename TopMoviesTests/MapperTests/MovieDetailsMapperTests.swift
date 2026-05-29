//
//  MovieDetailsMapperTests.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-24.
//

import XCTest
@testable import TopMovies

final class MovieDetailsMapperTests: XCTestCase {
    func test_movieDetailsDTO_toEntity() {
        let dto = MovieDetailsDTO(
            adult: false,
            backdropPath: "/backdrop.jpg",
            belongsToCollection: nil,
            budget: nil,
            genres: [
                Genre(id: 18, name: "Drama"),
                Genre(id: 11, name: "Action")
            ],
            homepage: nil,
            id: 550,
            imdbID: nil,
            originCountry: nil,
            originalLanguage: nil,
            originalTitle: nil,
            overview: "Some overview",
            popularity: nil,
            posterPath: "/poster.jpg",
            productionCompanies: nil,
            productionCountries: nil,
            releaseDate: nil,
            revenue: nil,
            runtime: 139,
            spokenLanguages: nil,
            status: nil,
            tagline: nil,
            title: "Fight Club",
            video: nil,
            voteAverage: 8.4,
            voteCount: nil
        )

        let entity = dto.toEntity()

        XCTAssertEqual(entity.id, 550)
        XCTAssertEqual(entity.title,
                       "Fight Club")

        XCTAssertEqual(entity.runtime,
                       139)

        XCTAssertEqual(entity.genres,
                       ["Drama", "Action"])
    }
}
