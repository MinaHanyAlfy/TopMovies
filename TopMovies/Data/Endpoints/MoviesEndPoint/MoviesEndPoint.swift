//
//  MoviesEndPoint.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-24.
//

import Foundation

enum MoviesEndPoint: Endpoint {
    case nowPlaying(page: Int)
    case upComing(page: Int)
    case popular(page: Int)
    case movieDetails(movieId: Int)
    
    var path: String {
        switch self {
        case .nowPlaying: return "/3/movie/now_playing"
        case .upComing: return "/3/movie/upcoming"
        case .popular: return "/3/movie/popular"
        case .movieDetails(let id): return "/3/movie/\(id)"
        }
    }

    var method: HttpMethod {
        switch self {
        case .nowPlaying, .popular, .upComing, .movieDetails:
            return .get
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .nowPlaying(let page),
                .upComing(let page),
                .popular(let page):
            return [
                URLQueryItem(name: "page", value: "\(page)")
            ]
        case .movieDetails:
           return []
        }
    }
    
    var bodyParameters: Data? {
        switch self {
        default:
            return nil
        }
    }
}
