//
//  NetworkManager.swift
//
//  Created by Ostap Marchenko on 07.12.2025.
//

import Foundation

/// Global singleton for accessing the pre-configured transport layer.
/// Acts as a synchronous bridge to the actor-based `TransportRegistry`.
public actor NetworkManager {

    /// Returns the active network transport.
    /// If `configure()` has not been called, this returns a fallback transport that throws a configuration error.
    public static var shared: NetworkTransport {
        if let transport = _sharedInternal {
            return transport
        }
        // Return a safe fallback instead of crashing
        return UnconfiguredTransport()
    }

    /// Returns the active storage transport.
    /// Returns nil if storage has not been configured.
    public static var storage: StorageTransport? {
        return _storageInternal
    }

    // MARK: - Internal backing properties (must be static for a global manager)
    private static var _sharedInternal: NetworkTransport?
    private static var _storageInternal: StorageTransport?

    private init() {}

    /// One-time configuration method. Should be called at app launch (AppDelegate/SceneDelegate).
    ///
    /// - Parameters:
    ///   - network: The implementation of `NetworkTransport` (e.g., `URLSessionTransport` or `FirebaseTransport`).
    ///   - storage: The implementation of `StorageTransport` (optional).
    ///   - listener: A global listener for network errors (optional).
    public static func configure(
        network: NetworkTransport,
        storage: StorageTransport? = nil,
        listener: NetworkErrorListener? = nil
    ) {
        _sharedInternal = network
        _storageInternal = storage

        Task {
            await TransportRegistry.shared.configure(
                network: network,
                storage: storage,
                listener: listener
            )
        }
    }
}

// MARK: - Safe Fallback
/// A fallback transport used when the manager is accessed before configuration.
private struct UnconfiguredTransport: NetworkTransport {
    func request(path: String, method: HTTPMethod, body: RequestBody?, headers: [String : String]?) async throws -> NetworkResponse {
        print("⚠️ [NetworkManager] Error: Network layer used before configuration.")
        throw TypedBackendError<String>.configurationMissing
    }
}
