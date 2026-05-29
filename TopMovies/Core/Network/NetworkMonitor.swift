//
//  NetworkMonitor.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-27.
//

import Network

final class NetworkMonitor {

    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    private(set) var isConnected = false

    /// Called whenever network changes
    var onChange: ((Bool) -> Void)?

    /// Called ONLY when connection is restored (important for retry logic)
    var onConnectionRestored: (() -> Void)?

    private init() {
        startMonitoring()
    }

    private func startMonitoring() {

        monitor.pathUpdateHandler = { path in
            let isConnected = path.status == .satisfied

            DispatchQueue.main.async {
                NetworkMonitor.shared.onChange?(isConnected)

                if isConnected {
                    NetworkMonitor.shared.onConnectionRestored?()
                }
            }
        }

        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}
