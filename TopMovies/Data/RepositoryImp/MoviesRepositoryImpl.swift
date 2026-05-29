//
//  MoviesRepositoryImpl.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-24.
//

import Foundation

final class MoviesRepositoryImpl: MoviesRepository {
    private let networkClient: NetworkClientProtocol
    private let localClient:  MoviesLocalDataSource
    
    init(
        networkClient: NetworkClientProtocol,
        localClient: MoviesLocalDataSource
    ) {
        self.networkClient = networkClient
        self.localClient = localClient
    }
    
    func fetchMovies(
        endpoint: MoviesEndPoint,
        category: MovieCategory
    ) async throws
    -> [MovieEntity] {
        
        do {
            let response:
            PageResponse<MovieDTO> =
            
            try await networkClient
                .request(
                    endpoint:
                        endpoint
                )
            
            let entities =
            response.results
                .map {
                    $0.toEntity(
                        category
                    )
                }
            
            try localClient.save(
                movies: entities,
                category:
                    category
            )
            
            return entities
            
        } catch {
            return try localClient.fetch(
                category:
                    category
            )
        }
    }
}

//MARK: - Fetching Movies
extension MoviesRepositoryImpl {
    func fetchNowPlaying(page: Int) async throws -> [MovieEntity] {
        try await fetchMovies(
            endpoint: .nowPlaying(page: page),
            category: .nowPlaying
        )
    }
    
    func fetchPopular(page: Int) async throws -> [MovieEntity] {
        try await fetchMovies(
            endpoint: .popular(page: page),
            category: .popular
        )
    }
    
    func fetchUpcoming(page: Int) async throws-> [MovieEntity] {
        try await fetchMovies(
            endpoint: .upComing(page: page),
            category: .upcoming
        )
    }
    
    func fetchMovieDetails(movieId: Int) async throws -> MovieDetailsEntity {
        do {
            let dto: MovieDetailsDTO = try await networkClient
                .request(
                    endpoint: MoviesEndPoint.movieDetails(movieId: movieId)
                )
            
            let entity = dto.toEntity()
            
            try localClient.saveMovieDetails(entity)
            return entity
        } catch {
            guard let cached = try localClient
                .fetchMovieDetails(
                    movieId: movieId
                )
            else {
                throw error
            }
            
            return cached
        }
    }
}
