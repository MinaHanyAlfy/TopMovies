//
//  NetworkError.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-24.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl
    case networkError(Error)
    case noData
    case decodingError(Error)
}
