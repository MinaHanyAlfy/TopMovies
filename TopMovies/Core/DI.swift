//
//  DI.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-27.
//

import SwiftData

final class DependencyContainer {
    lazy var networkClient = NetworkClient()
    lazy var modelContainer = try! ModelContainerFactory.create()
    
    lazy var context = ModelContext(
        modelContainer
    )

    lazy var localDataSource = MoviesLocalDataSourceImpl(
        context: context
    )

    lazy var moviesRepository = MoviesRepositoryImpl(
        networkClient: networkClient,
        localClient: localDataSource
    )

    lazy var imageRepository = ImageRepositoryImpl(
        networkClient: networkClient
    )

    func makeFetchNowPlaying() -> FetchNowPlayingUseCase {
        FetchNowPlayingUseCase(
            repository: moviesRepository
        )
    }
    
    func makeFetchPopular() -> FetchPopularMoviesUseCase {
        FetchPopularMoviesUseCase(
            repository: moviesRepository
        )
    }
    
    func makeFetchUpComing() -> FetchUpcomingMoviesUseCase {
        FetchUpcomingMoviesUseCase(
            repository: moviesRepository
        )
    }

    func makeFetchDetails() -> FetchMovieDetailsUseCase {
        FetchMovieDetailsUseCase(
            repository: moviesRepository
        )
    }

    func makeDownloadImage() -> DownloadImageUseCase {
        DownloadImageUseCase(
            repository: imageRepository
        )
    }
}
