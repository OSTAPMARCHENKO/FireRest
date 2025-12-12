//
//  NetworkErrorListener.swift
//
//  Created by Ostap Marchenko on 07.12.2025.
//

import Foundation

// MARK: - Global Error Listener

/// Protocol to intercept all errors globally.
/// Useful for logging, analytics, or handling session expiration (401).
public protocol NetworkErrorListener: Sendable {
    /// Called whenever a request fails (network, decoding, or backend error).
    func didReceive(error: Error, on path: String) async
}
