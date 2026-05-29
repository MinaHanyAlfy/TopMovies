//
//  MockModelContainer.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-27.
//

import Foundation
import SwiftData
@testable import TopMovies

enum MockModelContainer {

    static func make() throws -> ModelContainer {
        let configuration =
            ModelConfiguration(
                isStoredInMemoryOnly: true
            )

        return try ModelContainer(
            for:
                MovieEntity.self,
                MovieDetailsEntity.self,
            configurations:
                configuration
        )
    }
}
