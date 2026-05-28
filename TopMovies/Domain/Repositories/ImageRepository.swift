//
//  ImageRepository.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-24.
//

import Foundation
import UIKit

protocol ImageRepository {
    func fetchImage(from path: String) async throws -> UIImage
}
