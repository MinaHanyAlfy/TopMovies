//
//  MovieCategory.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-27.
//

extension MovieCategory {
    var title: String {
        switch self {
            
        case .nowPlaying:
            return "Now Playing"
            
        case .popular:
            return "Popular"
            
        case .upcoming:
            return "Upcoming"
        }
    }

    var icon: String {
        switch self {

        case .nowPlaying:
            return "nowPlaying"

        case .popular:
            return "popular"

        case .upcoming:
            return "upcomingNext"
        }
    }
}
