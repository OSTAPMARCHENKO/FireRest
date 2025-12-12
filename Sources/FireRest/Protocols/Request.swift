//
//  Request.swift
//
//  Created by Ostap Marchenko on 07.12.2025.
//

import Foundation
import Combine

/// Base Request protocol for high-level declarative requests.
///
/// Defines the structure of a request, including the expected response type and error model.
public protocol Request: Sendable {
    /// The expected model for a successful response.
    associatedtype ResponseObjectType: Decodable & Sendable
    
    /// The expected model for a backend error (e.g., a specific API error object).
    associatedtype ErrorType: Decodable & Sendable
    
    var path: String { get }
    var method: HTTPMethod { get }
    var body: RequestBody? { get }
    var headers: [String: String]? { get }
    var transport: NetworkTransport? { get }
}

// Default implementation for optional properties
public extension Request {
    var headers: [String: String]? { nil }
    var body: RequestBody? { nil }
    var transport: NetworkTransport? { nil }
}

/// Execution logic extension using async/await.
public extension Request {
    
    /// Executes the request using the globally configured transport or a locally provided one.
    ///
    /// - Parameter retry: The retry policy for network failures.
    /// - Returns: The decoded `ResponseObjectType`.
    /// - Throws: `TypedBackendError` containing either a network error, decoding error, or a typed backend error.
    func execute(retry: RetryPolicy = .default) async throws -> ResponseObjectType {
        let listener = await TransportRegistry.shared.errorListener
        
        // Resolve transport: prefer local, fallback to global
        let activeTransport: NetworkTransport
        if let localTransport = self.transport {
            activeTransport = localTransport
        } else {
            activeTransport = NetworkManager.shared
        }
        
        var attempt = 1
        
        while true {
            do {
                // 1. Perform Network Call
                let response = try await activeTransport.request(path: path, method: method, body: body, headers: headers)
                let data = response.data
                let status = response.statusCode
                
                // 2. Validate HTTP Status Code
                switch status {
                case 200...299:
                    // Success Range
                    do {
                        return try JSONDecoder().decode(ResponseObjectType.self, from: data)
                    } catch {
                        throw TypedBackendError<ErrorType>.decodingFailed(data: data, underlying: error)
                    }
                    
                default:
                    // Error Range (4xx, 5xx)
                    // Try to decode the expected custom ErrorType
                    if let backendError = try? JSONDecoder().decode(ErrorType.self, from: data) {
                        throw TypedBackendError<ErrorType>.backend(backendError, statusCode: status)
                    } else {
                        // If we can't decode the specific error model, throw a generic server error
                        throw TypedBackendError<ErrorType>.serverError(statusCode: status, data: data)
                    }
                }
                
            } catch {
                // 3. Error Handling & Retry Logic
                let finalError: TypedBackendError<ErrorType>
                
                if let typed = error as? TypedBackendError<ErrorType> {
                    finalError = typed
                } else {
                    // Wrap raw transport errors (e.g., URLError, Offline)
                    finalError = .network(error)
                }
                
                // Check if we should retry
                // We retry only on network-level errors, not on valid backend errors (like 400 Bad Request)
                let shouldRetry: Bool
                if case .network = finalError {
                    shouldRetry = true
                } else if case .serverError(let code, _) = finalError, code >= 500 {
                    // Optionally retry on 5xx server errors
                    shouldRetry = true
                } else {
                    shouldRetry = false
                }
                
                if shouldRetry && attempt < retry.maxAttempts {
                    attempt += 1
                    let delay = retry.baseDelay * pow(2.0, Double(attempt - 1))
                    try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                    continue
                }
                
                // 4. Report to Global Listener (if configured)
                await listener?.didReceive(error: finalError, on: path)
                
                throw finalError
            }
        }
    }
}
