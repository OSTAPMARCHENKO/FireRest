//
//  NetworkResponse.swift
//
//  Created by Ostap Marchenko on 12.12.2025.
//

import Foundation

/// Represents a standardized network response independent of the underlying transport (HTTP, Firebase, etc.).
public struct NetworkResponse: Sendable {
    /// The raw body data received from the server.
    public let data: Data
    
    /// The HTTP status code (e.g., 200, 404, 500).
    /// For non-HTTP transports (like Firebase), this can be simulated (e.g., 200 for success).
    public let statusCode: Int
    
    /// Response headers.
    public let headers: [String: String]
    
    public init(data: Data, statusCode: Int, headers: [String: String] = [:]) {
        self.data = data
        self.statusCode = statusCode
        self.headers = headers
    }
}
