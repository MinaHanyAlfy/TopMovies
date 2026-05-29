//
//  AppCoordinator.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-27.
//

import UIKit

final class AppCoordinator: @MainActor Coordinator {

    private let container: DependencyContainer
    private var childCoordinators:
        [Coordinator] = []
    
    init(
        container: DependencyContainer
    ) {
        self.container =
            container
    }

    @MainActor
    func start() {
        
        let tabBar = UITabBarController()
        
        let nowPlaying = MoviesCoordinator(
            category: .nowPlaying,
            container: container
        )
        
        let popular = MoviesCoordinator(
            category: .popular,
            container: container
        )
        
        let upcoming = MoviesCoordinator(
            category: .upcoming,
            container: container
        )
        
        nowPlaying.start()
        popular.start()
        upcoming.start()
        
        childCoordinators = [
            nowPlaying,
            popular,
            upcoming
        ]
        
        tabBar.viewControllers = [
            nowPlaying.navigationController,
            popular.navigationController,
            upcoming.navigationController
        ]
        
        // IMPORTANT: tabBar is root now
        UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .windows
            .first?
            .rootViewController = tabBar
    }
}
