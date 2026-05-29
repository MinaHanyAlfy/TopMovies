//
//  ViewState.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-29.
//


import Foundation

enum ViewState: Equatable {
    case idle
    case loading
    case loaded
    case empty(message: String)
    case error(message: String)
}
