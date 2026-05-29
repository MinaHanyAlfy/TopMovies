//
//  MovieDetailsViewModel.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-29.
//

import UIKit

@MainActor
final class MovieDetailsViewModel {

    private let movieId: Int
    private let useCase: FetchMovieDetailsUseCaseProtocol
    private let imageRepo: DownloadImageUseCaseProtocol

    private(set) var movie: MovieDetailsEntity?

    var state: ViewState = .idle

    init(
        movieId: Int,
        useCase: FetchMovieDetailsUseCaseProtocol,
        imageRepo: DownloadImageUseCaseProtocol
    ) {
        self.movieId = movieId
        self.useCase = useCase
        self.imageRepo = imageRepo
    }

    func fetchMovieDetails() async {

        state = .loading

        do {

            let details =
                try await useCase.execute(
                    movieId: movieId
                )

            movie = details

            state = .loaded
        }

        catch let error as NetworkError {

            switch error {

            case .networkError:

                state = .error(
                    message:
                    "No internet connection."
                )

            default:

                state = .error(
                    message:
                    "Failed loading movie details."
                )
            }
        }

        catch {

            state = .error(
                message:
                "Unexpected error occurred."
            )
        }
    }

    func loadPoster() async -> UIImage? {
        guard let poster =
            movie?.posterPath
        else {
            return nil
        }

        return try? await imageRepo
            .execute(path: poster)
    }
}
