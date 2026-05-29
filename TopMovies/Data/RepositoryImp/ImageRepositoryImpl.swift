//
//  ImageRepositoryImpl.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-24.
//

import Foundation
import UIKit

final class ImageRepositoryImpl: ImageRepository {
    private let networkClient: NetworkClientProtocol
    private let cache = NSCache<NSString, UIImage>()
    
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    func fetchImage(
           from path: String
       ) async throws -> UIImage {
           let fullPath = "https://image.tmdb.org/t/p/w500\(path)"

           let key = NSString(string: fullPath)

           if let cached = cache.object(forKey: key) {
               return cached
           }

           let data = try await networkClient
               .downloadImage(from: fullPath)
           
           guard let image = UIImage(data: data)
           else { throw NetworkError.invalidUrl }

           cache.setObject(
            image,
            forKey: key
           )

           return image
       }
}
