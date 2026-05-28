//
//  Coordinator.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-27.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }

    func start()
}
