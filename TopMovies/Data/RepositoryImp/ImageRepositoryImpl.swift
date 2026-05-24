//
//  ImageRepositoryImpl.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-24.
//

import Foundation

final class ImageRepositoryImpl: ImageRepository {

    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    func fetchImage(
        from urlString: String
    ) async throws -> Data {

        try await networkClient
            .downloadImage(from: urlString)
    }
}
