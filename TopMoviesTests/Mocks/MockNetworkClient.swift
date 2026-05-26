//
//  MockNetworkClient.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-24.
//

import Foundation
@testable import TopMovies

final class MockNetworkClient: NetworkClientProtocol {
    var mockResponse: Any?
    var shouldThrowError = false

    func request<T: Decodable>(
        endpoint: Endpoint
    ) async throws -> T {

        if shouldThrowError {
            throw NetworkError.invalidUrl
        }

        guard let response = mockResponse as? T else {
            fatalError(
                "Mock type mismatch. Expected \(T.self)"
            )
        }

        return response
    }

    func downloadImage(
        from urlString: String
    ) async throws -> Data {

        if shouldThrowError {
            throw NetworkError.invalidUrl
        }

        return Data("fake-image".utf8)
    }
}
