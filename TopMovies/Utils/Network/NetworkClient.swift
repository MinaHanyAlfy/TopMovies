//
//  NetworkClient.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-24.
//

import Foundation

protocol NetworkClientProtocol {
    func request<T: Decodable>(endpoint: Endpoint) async throws -> T
    func downloadImage(from urlString: String) async throws -> Data
}

class NetworkClient: NetworkClientProtocol {
    private let session: URLSession
    private let logger: Logger
    
    init(session: URLSession = .shared,
         logger: Logger = NetworkingLogger()) {
        self.session = session
        self.logger = logger
    }
    
    func request<T: Decodable>(endpoint: Endpoint) async throws -> T {
        guard let url = buildURL(for: endpoint) else {
            throw NetworkError.invalidUrl
        }
        
        let request = createURLRequest(for: endpoint, with: url)
        let requestInfo = logRequestWith(request)
        
        do {
            let (data, _) = try await session.data(for: request)
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            logger.log(message: "Successful response from: \(requestInfo)", level: .info)
            return decodedResponse
        } catch {
            logger.log(message: "Decoding error for: \(requestInfo) with error: \(error)", level: .error)
            throw NetworkError.decodingError(error)
        }
    }
    
    func downloadImage(from urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else { throw NetworkError.invalidUrl }
        do {
            let (data, _) = try await session.data(from: url)
            return data
        } catch {
            throw NetworkError.networkError(error)
        }
    }

    // MARK: - Private Helpers
    private func buildURL(
        for endpoint: Endpoint
    ) -> URL? {

        var components = URLComponents(
            string: endpoint.basePath
        )

        components?.path = endpoint.path
        components?.queryItems = endpoint.defaultQueryItems + (
            endpoint.queryItems.isEmpty
            ? []
            : endpoint.queryItems
            )

        return components?.url
    }
    
    private func createURLRequest(for endpoint: Endpoint, with url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(Configuration.apiToken)", forHTTPHeaderField: "Authorization")
        if let bodyParameters = endpoint.bodyParameters {
            request.httpBody = bodyParameters
        }
        return request
    }
    
    private func logRequestWith(_ request: URLRequest) -> String {
        let safeUrlString = request.url?.absoluteString ?? "Invalid URL"
        let requestInfo = "\(request.httpMethod ?? "GET") \(safeUrlString)"
        logger.log(message: "Starting request: \(requestInfo)", level: .info)
        return requestInfo
    }
}
