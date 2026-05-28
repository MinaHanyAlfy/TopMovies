//
//  MoviesLocalDataSourceImpl.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-27.
//

import Foundation
import SwiftData

final class MoviesLocalDataSourceImpl: MoviesLocalDataSource {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func save(
        movies: [MovieEntity],
        category: MovieCategory
    ) throws {
        try delete(category: category)
        
        movies.forEach { context.insert($0) }
        try context.save()
    }
    
    private func delete(category: MovieCategory) throws {
        let movies =
        try fetch(category: category)
        
        movies.forEach {context.delete($0)}
    }
    
    func fetch(category: MovieCategory) throws -> [MovieEntity] {
        let descriptor = FetchDescriptor<MovieEntity>(
              predicate: #Predicate<MovieEntity> { model in
                  // Compare the stored primitive string to our target string
                  model.categoryValue == category.rawValue
              }
          )
        return try context.fetch(descriptor)
    }
    
    
    func saveMovieDetails(_ details: MovieDetailsEntity) throws {
        context.insert(details)
        
        try context.save()
    }
    
    func fetchMovieDetails(movieId: Int) throws -> MovieDetailsEntity? {
        let descriptor = FetchDescriptor<MovieDetailsEntity>(
            predicate:
                #Predicate {
                    $0.id == movieId
                }
        )
        
        return try context.fetch(descriptor).first
    }
}
