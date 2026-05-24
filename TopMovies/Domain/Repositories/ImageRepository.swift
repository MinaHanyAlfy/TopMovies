//
//  ImageRepository.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-24.
//

import Foundation

protocol ImageRepository {
    func fetchImage(from urlString: String) async throws -> Data
}
