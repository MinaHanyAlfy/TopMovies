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
            viewModel: vm
        )

        vc.coordinator = self

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

    func showDetails(
        movieId: Int
    ) {
        //
    }
}
