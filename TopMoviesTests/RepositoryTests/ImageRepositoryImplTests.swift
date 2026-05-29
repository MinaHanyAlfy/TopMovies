//
//  ImageRepositoryImplTests.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-24.
//

import XCTest
@testable import TopMovies

final class ImageRepositoryImplTests: XCTestCase {
    func test_fetchImage_returnsValidImage() async throws {
        let mockClient = MockNetworkClient()
        let repository = ImageRepositoryImpl(networkClient: mockClient)

        let image = try await repository.fetchImage(from: "/dummy-url")

        XCTAssertNotNil(image)
        XCTAssertGreaterThan(image.size.width, 0)
        XCTAssertGreaterThan(image.size.height, 0)
    }
}
