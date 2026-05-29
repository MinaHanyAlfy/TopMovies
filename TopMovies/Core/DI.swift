//
//  DI.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-27.
//

import SwiftData

final class DependencyContainer {

    // MARK: - Core
    let networkClient: NetworkClient
    let modelContainer: ModelContainer

    init() throws {

        self.networkClient = NetworkClient()

        self.modelContainer =
            try ModelContainerFactory.create()
    }

    // MARK: - Context (SAFE per access)
    @MainActor
    var context: ModelContext {
        modelContainer.mainContext
    }

    // MARK: - DataSources
    @MainActor
    func makeLocalDataSource() -> MoviesLocalDataSourceImpl {
        MoviesLocalDataSourceImpl(
            context: context
        )
    }

    // MARK: - Repositories
    @MainActor
    func makeMoviesRepository() -> MoviesRepositoryImpl {
        MoviesRepositoryImpl(
            networkClient: networkClient,
            localClient: makeLocalDataSource()
        )
    }

    func makeImageRepository() -> ImageRepositoryImpl {

        ImageRepositoryImpl(
            networkClient: networkClient
        )
    }

    // MARK: - UseCases
    @MainActor
    func makeFetchNowPlaying() -> FetchNowPlayingUseCaseProtocol {
        FetchNowPlayingUseCase(
            repository: makeMoviesRepository()
        )
    }

    @MainActor
    func makeFetchPopular() -> FetchPopularMoviesUseCaseProtocol {
        FetchPopularMoviesUseCase(
            repository: makeMoviesRepository()
        )
    }
    
    @MainActor
    func makeFetchUpComing() -> FetchUpcomingMoviesUseCaseProtocol {
        FetchUpcomingMoviesUseCase(
            repository: makeMoviesRepository()
        )
    }
    
    @MainActor
    func makeFetchDetails() -> FetchMovieDetailsUseCaseProtocol {
        FetchMovieDetailsUseCase(
            repository: makeMoviesRepository()
        )
    }
    
    @MainActor
    func makeDownloadImage() -> DownloadImageUseCaseProtocol {
        DownloadImageUseCase(
            repository: makeImageRepository()
        )
    }
}
