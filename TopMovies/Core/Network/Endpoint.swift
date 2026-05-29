//
//  Endpoint.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-24.
//

import Foundation

protocol Endpoint {
    var basePath: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
    var method: HttpMethod { get }
    var bodyParameters: Data? { get }
    var defaultQueryItems: [URLQueryItem] { get }
}

extension Endpoint {
    var basePath: String { "https://api.themoviedb.org" }
    
    var defaultQueryItems: [URLQueryItem] {
        [URLQueryItem(name: "language", value: "en-US")]
    }
    
    var url: URL? {
        var components = URLComponents(string: basePath)
        components?.path = path
        components?.queryItems = defaultQueryItems + queryItems
        
        return components?.url
    }
    
    var queryItems: [URLQueryItem] {[]}
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}
