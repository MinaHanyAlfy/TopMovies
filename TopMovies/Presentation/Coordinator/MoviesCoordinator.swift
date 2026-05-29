//
//  MoviesCoordinator.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-27.
//

import UIKit

final class MoviesCoordinator: @MainActor Coordinator {
    let navigationController = UINavigationController()

    private let category: MovieCategory
    private let container: DependencyContainer

    init(
        category: MovieCategory,
        container: DependencyContainer
    ) {
        self.category = category
        self.container = container
    }

    @MainActor
    func start() {
        let vm = MoviesListViewModel(
            category: category,
            container: container
        )

        let vc = MoviesViewController(
            viewModel: vm,
            coordinator: self
        )
        
        navigationController.viewControllers = [vc]

        navigationController
            .tabBarItem =
            UITabBarItem(
                title: category.title,
                image: UIImage(
                    named: category.icon
                ),
                tag: 0
            )
    }

    @MainActor
    func showDetails(
        movieId: Int
    ) {
        let useCase =
            FetchMovieDetailsUseCase(
                repository: container.makeMoviesRepository()
            )

        let vm =
            MovieDetailsViewModel(
                movieId: movieId,
                useCase: useCase,
                imageRepo: container.makeDownloadImage()
            )
        let vc = MovieDetailsViewController(
            viewModel: vm,
            coordinator: self
        )
        
        navigationController
            .pushViewController(
                vc,
                animated: true
            )
    }
}
