//
//  AppCoordinator.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-27.
//

import UIKit

final class AppCoordinator: @MainActor Coordinator {

    let navigationController =
        UINavigationController()

    private let container: DependencyContainer

    init(
        container: DependencyContainer
    ) {
        self.container =
            container
    }

    @MainActor
    func start() {

        let tabBar =
            UITabBarController()

        let nowPlaying =
            MoviesCoordinator(
                category:
                    .nowPlaying,
                container:
                    container
            )

        let popular =
            MoviesCoordinator(
                category:
                    .popular,
                container:
                    container
            )

        let upcoming =
            MoviesCoordinator(
                category:
                    .upcoming,
                container:
                    container
            )

        nowPlaying.start()
        popular.start()
        upcoming.start()

        tabBar.viewControllers = [
            nowPlaying.navigationController,
            popular.navigationController,
            upcoming.navigationController
        ]

        navigationController
            .setViewControllers(
                [tabBar],
                animated: false
            )
    }
}
