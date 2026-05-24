//
//  MovieDetailsDTOTests.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-24.
//

import XCTest
@testable import TopMovies

final class MovieDetailsDTOTests: XCTestCase {
    
    func test_decodeMovieDetailsDTO() throws {
        
        let json = """
               {
                   "id": 550,
                   "title": "Fight Club",
                   "overview": "Some overview",
                   "runtime": 139,
                   "poster_path": "/poster.jpg",
                   "backdrop_path": "/backdrop.jpg",
                   "vote_average": 8.4,
                   "genres": [
                       {
                           "id": 18,
                           "name": "Drama"
                       },
                       {
                           "id": 53,
                           "name": "Thriller"
                       }
                   ]
               }
               """
        let data = Data(json.utf8)
        
        let dto = try JSONDecoder()
            .decode(MovieDetailsDTO.self,
                    from: data)
        
        XCTAssertEqual(dto.id, 550)
        XCTAssertEqual(dto.title, "Fight Club")
        XCTAssertEqual(dto.overview,
                       "Some overview")
        XCTAssertEqual(dto.runtime, 139)
        
        XCTAssertEqual(dto.posterPath,
                       "/poster.jpg")
        
        XCTAssertEqual(dto.backdropPath,
                       "/backdrop.jpg")
        
        XCTAssertEqual(dto.voteAverage, 8.4)
        
        XCTAssertEqual(dto.genres?.count, 2)
        
        XCTAssertEqual(dto.genres?.first?.id,
                       18)
        
        XCTAssertEqual(dto.genres?.first?.name,
                       "Drama")
    }
}
