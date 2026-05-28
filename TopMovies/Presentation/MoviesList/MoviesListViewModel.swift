//
//  MoviesListViewModel.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-28.
//

import Foundation
import Combine

@MainActor
final class MoviesListViewModel {

    // MARK: - Published State
    @Published private(set) var movies:
        [MovieEntity] = []
    @Published private(set) var isLoading =
        false

    @Published private(set) var errorMessage:
        String?

    // MARK: - Dependencies
    private let category:
        MovieCategory

    private let fetchNowPlaying:
        FetchNowPlayingUseCase

    private let fetchPopular:
        FetchPopularMoviesUseCase

    private let fetchUpcoming:
        FetchUpcomingMoviesUseCase

    let downloadImageUseCase:
        DownloadImageUseCase

    // MARK: - Pagination
    private var currentPage = 1
    private var hasMorePages = true

    // MARK: - Init
    init(
        category: MovieCategory,
        container: DependencyContainer
    ) {

        self.category =
            category

        self.fetchNowPlaying =
            container.makeFetchNowPlaying()

        self.fetchPopular =
            container.makeFetchPopular()

        self.fetchUpcoming =
            container.makeFetchUpComing()

        self.downloadImageUseCase =
            container.makeDownloadImage()
    }

    // MARK: - Public Methods
    func fetchMovies(
        refresh: Bool = false
    ) async throws {

        guard !isLoading else {
            return
        }

        if refresh {

            resetPagination()
        }

        guard hasMorePages else {
            return
        }

        isLoading = true
        errorMessage = nil

        defer {

            isLoading = false
        }

        do {

            let newMovies =
                try await loadMovies()

            if newMovies.isEmpty {
                hasMorePages = false
                return
            }

            movies.append(
                contentsOf:
                newMovies
            )

            currentPage += 1
        } catch {

            errorMessage =
                error.localizedDescription

            print(
                "Movies fetch error:",
                error
            )
        }
    }

    func movie(
        at index: Int
    ) -> MovieEntity {

        movies[index]
    }
}

// MARK: - Private Helpers
private extension MoviesListViewModel {
    func loadMovies()
    async throws -> [MovieEntity] {

        switch category {

        case .nowPlaying:
            return try await
                fetchNowPlaying
                    .execute(
                        page:
                        currentPage
                    )
        case .popular:
            return try await
                fetchPopular
                    .execute(
                        page:
                        currentPage
                    )
        case .upcoming:
            return try await
                fetchUpcoming
                    .execute(
                        page:
                        currentPage
                    )
        }
    }

    func resetPagination() {
        currentPage = 1
        hasMorePages = true
        movies.removeAll()
    }
}
