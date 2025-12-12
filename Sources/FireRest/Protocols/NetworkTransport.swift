//
//  NetworkTransport.swift
//
//  Created by Ostap Marchenko on 07.12.2025.
//

import Foundation

/// Responsible for executing raw requests.
/// Implementations of this protocol serve as the bridge between the app and the network layer
/// (e.g., URLSession, Alamofire, or a Firebase wrapper).
///
/// Must be thread-safe (`Sendable`).
public protocol NetworkTransport: Sendable {
    
    /// Executes a request and returns a standardized response.
    ///
    /// - Parameters:
    ///   - path: The endpoint path (e.g., "/users" for REST or "collection/doc" for DBs).
    ///   - method: The HTTP method to use.
    ///   - body: The request payload (optional).
    ///   - headers: Custom headers for this request.
    /// - Returns: A `NetworkResponse` containing data and metadata.
    /// - Throws: A transport-level error (e.g., connectivity issues).
    func request(
        path: String,
        method: HTTPMethod,
        body: RequestBody?,
        headers: [String: String]?
    ) async throws -> NetworkResponse
}
