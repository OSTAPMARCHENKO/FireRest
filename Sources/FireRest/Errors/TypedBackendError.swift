//
//  TypedBackendError.swift
//
//  Created by Ostap Marchenko on 07.12.2025.
//

import Foundation

/// A strongly-typed wrapper for backend and network errors.
/// Provides a unified interface for handling decoding failures, network issues, and API-specific errors.
public enum TypedBackendError<ErrorType: Decodable & Sendable>: Error, LocalizedError, Sendable {
    
    /// The backend returned a known error object (successfully decoded from JSON).
    /// Includes the HTTP status code.
    case backend(ErrorType, statusCode: Int)
    
    /// The server returned an error status (e.g., 404, 500), but the body could not be decoded into `ErrorType`.
    /// Useful for handling raw HTML errors or empty bodies.
    case serverError(statusCode: Int, data: Data)
    
    /// Data was received successfully (200 OK), but failed to match the expected `ResponseObjectType` structure.
    case decodingFailed(data: Data, underlying: Error)
    
    /// A transport/connectivity level error (e.g., no internet, timeout).
    case network(Error)
    
    /// The NetworkManager was not configured before use.
    case configurationMissing
    
    public var errorDescription: String? {
        switch self {
        case .backend(let typed, let code):
            return "API Error (\(code)): \((typed as? LocalizedError)?.errorDescription ?? String(describing: typed))"
        case .serverError(let code, _):
            return "Server Error: received status code \(code), but could not decode error details."
        case .decodingFailed(_, let underlying):
            return "Decoding Failed: \(underlying.localizedDescription)"
        case .network(let err):
            return "Network Error: \(err.localizedDescription)"
        case .configurationMissing:
            return "Configuration Error: NetworkTransport not initialized."
        }
    }
}
