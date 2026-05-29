//
//  ModelContainer.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-27.
//

import Foundation
import SwiftData

enum ModelContainerFactory {
    static func create() throws -> ModelContainer {
        try ModelContainer(
            for:
                MovieEntity.self,
                MovieDetailsEntity.self
        )
    }
}
