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
    @Published private(set) var state: ViewState = .idle


    // MARK: - Dependencies
    private let category: MovieCategory
    
    private let fetchNowPlaying: FetchNowPlayingUseCaseProtocol
    private let fetchPopular: FetchPopularMoviesUseCaseProtocol
    private let fetchUpcoming: FetchUpcomingMoviesUseCaseProtocol
    
    let downloadImageUseCase: DownloadImageUseCaseProtocol
   
    // MARK: - Pagination
    private var currentPage = 1
    private var hasMorePages = true
    private var isFetching = false

    // MARK: - Init
    init(
        category: MovieCategory,
        container: DependencyContainer
    ) {
        self.category = category
        
        self.fetchNowPlaying = container.makeFetchNowPlaying()
        self.fetchPopular = container.makeFetchPopular()
        self.fetchUpcoming = container.makeFetchUpComing()
        
        self.downloadImageUseCase = container.makeDownloadImage()
    }

    // MARK: - Public Methods
    func fetchMovies(refresh: Bool = false) async {
        
        guard !isFetching else { return }
        guard refresh || hasMorePages else { return }
        
        if refresh {
            resetPagination()
        }
        
        isFetching = true
        state = .loading
        
        do {
            
            let newMovies = try await loadMovies()
            
            if refresh {
                movies = newMovies
            } else {
                movies.append(contentsOf: newMovies)
            }
            
            currentPage += 1
            
            hasMorePages = !newMovies.isEmpty
            
            state = movies.isEmpty
            ? .empty(message: "No movies available.")
            : .loaded
            
        } catch {
            state = .error(message: error.localizedDescription)
        }
        
        isFetching = false
    }


    func movie(
        at index: Int
    ) -> MovieEntity {

        movies[index]
    }
}

// MARK: - Private Helpers
private extension MoviesListViewModel {
    
    func loadMovies() async throws -> [MovieEntity] {
        
        switch category {
            
        case .nowPlaying:
            return try await fetchNowPlaying.execute(page: currentPage)
            
        case .popular:
            return try await fetchPopular.execute(page: currentPage)
            
        case .upcoming:
            return try await fetchUpcoming.execute(page: currentPage)
        }
    }
    
    func resetPagination() {
        currentPage = 1
        hasMorePages = true
        movies.removeAll()
    }
}
