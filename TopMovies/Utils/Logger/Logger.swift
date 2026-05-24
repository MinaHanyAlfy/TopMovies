//
//  Logger.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-24.
//

import Foundation

protocol Logger {
    func log(message: String, level: LogLevel)
}

enum LogLevel: String {
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
    case debug = "DEBUG"
    
    var icon: String {
        switch self {
        case .info:
            return "ℹ️"
        case .warning:
            return "⚠️"
        case .error:
            return "‼️"
        case .debug:
            return "🐛"
        }
    }
}

class NetworkingLogger: Logger {
    func log(message: String, level: LogLevel) {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .long)
        print("\(timestamp) 📡 [Networking] \(level.icon) [\(level.rawValue)] \(message)")
    }
}
