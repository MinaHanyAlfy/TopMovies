//
//  PageResponseTests.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-24.
//

import XCTest
@testable import TopMovies

final class PageResponseTests: XCTestCase {
    func test_decodePageResponse() throws {
        let json = """
        {
            "page": 1,
            "results": [
                {
                    "id": 550,
                    "title": "Fight Club",
                    "overview": "Some overview",
                    "poster_path": "/poster.jpg",
                    "vote_average": 8.4
                }
            ],
            "total_pages": 10,
            "total_results": 200,
            "dates": {
                "maximum": "2026-05-01",
                "minimum": "2026-04-01"
            }
        }
        """

        let data = Data(json.utf8)

        let response = try JSONDecoder()
            .decode(PageResponse<MovieDTO>.self,
                    from: data)

        XCTAssertEqual(response.page, 1)
        XCTAssertEqual(response.totalPages, 10)
        XCTAssertEqual(response.totalResults, 200)

        XCTAssertEqual(response.results.count, 1)

        XCTAssertEqual(response.results.first?.id, 550)
        XCTAssertEqual(response.results.first?.title,
                       "Fight Club")

        XCTAssertEqual(response.dates?.maximum,
                       "2026-05-01")

        XCTAssertEqual(response.dates?.minimum,
                       "2026-04-01")
    }
}
