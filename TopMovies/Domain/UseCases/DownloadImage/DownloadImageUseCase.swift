//
//  DownloadImageUseCase.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-25.
//

import Foundation
import UIKit

protocol DownloadImageUseCaseProtocol {
    func execute(path: String) async throws -> UIImage
}

final class DownloadImageUseCase: DownloadImageUseCaseProtocol {
    private let repository: ImageRepository

    init(
        repository: ImageRepository
    ) {
        self.repository = repository
    }

    func execute(
        path: String
    ) async throws -> UIImage {
        try await repository.fetchImage(from: path)
    }
}
