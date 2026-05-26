//
//  DownloadImageUseCase.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-25.
//
import Foundation

protocol DownloadImageUseCaseProtocol {
    func execute(url: String) async throws -> Data
}

final class DownloadImageUseCase: DownloadImageUseCaseProtocol {
    private let repository: ImageRepository

    init(
        repository: ImageRepository
    ) {
        self.repository = repository
    }

    func execute(
        url: String
    ) async throws -> Data {

        try await repository
            .fetchImage(
                from: url
            )
    }
}
