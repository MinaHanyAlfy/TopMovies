//
//  MovieDTOTests.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-24.
//

import XCTest
@testable import TopMovies

final class MovieDTOTests: XCTestCase {
    func test_decodeMovieDTO() throws {
        let json = """
        {
            "id": 550,
            "title": "Fight Club",
            "overview": "Some overview",
            "poster_path": "/poster.jpg",
            "vote_average": 8.4
        }
        """

        let data = Data(json.utf8)
        
        let dto = try JSONDecoder()
            .decode(MovieDTO.self, from: data)

        XCTAssertEqual(dto.id, 550)
        XCTAssertEqual(dto.title, "Fight Club")
        XCTAssertEqual(dto.posterPath, "/poster.jpg")
        XCTAssertEqual(dto.voteAverage, 8.4)
    }
}
