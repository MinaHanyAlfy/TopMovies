//
//  MoviesRepositoryImpl.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-24.
//

import Foundation

final class MoviesRepositoryImpl: MoviesRepository {

    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    func fetchNowPlaying(page: Int) async throws -> [MovieEntity] {
        let response: PageResponse<MovieDTO> =
            try await networkClient.request(
                endpoint: MoviesEndPoint.nowPlaying(page: page)
            )

        return response.results.map { $0.toEntity() }
    }

    func fetchPopular(page: Int) async throws -> [MovieEntity] {
        let response: PageResponse<MovieDTO> =
            try await networkClient.request(
                endpoint: MoviesEndPoint.popular(page: page)
            )

        return response.results.map { $0.toEntity() }
    }

    func fetchUpcoming(page: Int) async throws -> [MovieEntity] {
        let response: PageResponse<MovieDTO> =
            try await networkClient.request(
                endpoint: MoviesEndPoint.upComing(page: page)
            )
       
        return response.results.map { $0.toEntity() }
    }

    func fetchMovieDetails(
        movieId: Int
    ) async throws -> MovieDetailsEntity {
        let dto: MovieDetailsDTO =
            try await networkClient.request(
                endpoint: MoviesEndPoint.movieDetails(movieId: movieId)
            )

        return dto.toEntity()
    }
}
