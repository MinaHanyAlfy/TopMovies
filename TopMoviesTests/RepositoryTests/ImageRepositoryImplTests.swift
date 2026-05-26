//
//  ImageRepositoryImplTests.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-24.
//

import XCTest
@testable import TopMovies

final class ImageRepositoryImplTests: XCTestCase {
    func test_fetchImage_returnsData() async throws {
        let mockClient =
            MockNetworkClient()

        let repository =
            ImageRepositoryImpl(
                networkClient: mockClient
            )

        let data =
            try await repository
                .fetchImage(
                    from: "dummy-url"
                )

        XCTAssertFalse(
            data.isEmpty
        )
    }
}
