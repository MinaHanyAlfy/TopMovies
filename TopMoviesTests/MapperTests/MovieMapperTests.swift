//
//  MovieMapperTests.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-24.
//

import XCTest
@testable import TopMovies

final class MovieMapperTests: XCTestCase {
    func test_movieDTO_toEntity() {
        let dto = MovieDTO(
            adult: true,
            backdropPath: nil,
            genreIDS: nil,
            id: 1,
            originalTitle: "Real Batman",
            overview: "Overview",
            originalLanguage: nil,
            popularity: nil,
            posterPath: "/poster.jpg",
            releaseDate: nil,
            title: "Batman",
            video: nil,
            voteAverage: 8.9,
            voteCount: nil
        )

        let entity = dto.toEntity(.nowPlaying)

        XCTAssertEqual(entity.id, 1)
        XCTAssertEqual(entity.title, "Batman")
        XCTAssertEqual(entity.originalTitle, "Real Batman")
        XCTAssertEqual(entity.adult, true)
    }
}
