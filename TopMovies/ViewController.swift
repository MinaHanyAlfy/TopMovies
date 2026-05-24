//
//  ViewController.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-23.
//

import UIKit

class ViewController: UIViewController {
    let network = NetworkClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let repo = MoviesRepositoryImpl(networkClient: network)
        Task {
            try await repo.fetchNowPlaying(page: 1)
        }
    }


}

