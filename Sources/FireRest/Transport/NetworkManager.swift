//
//  NetworkManager.swift
//
//  Created by Ostap Marchenko on 07.12.2025.
//

import Foundation

/// Global singleton for accessing the pre-configured transport layer.
/// Acts as a synchronous bridge to the actor-based TransportRegistry.
public actor NetworkManager {
    
    // MARK: - Public API
    
    /// Returns the active network transport.
    /// If configure() has not been called, this returns a fallback transport that throws a configuration error.
    public static var shared: NetworkTransport {
        // Safe thread-safe read
        if let transport = _state.network {
            return transport
        }
        return UnconfiguredTransport()
    }
    
    /// Returns the active storage transport.
    /// Returns nil if storage has not been configured.
    public static var storage: StorageTransport? {
        // Safe thread-safe read
        return _state.storage
    }
    
    // MARK: - Internal State (Thread Safe)
    
    /// A thread-safe container for global state.
    /// Replaces the non-isolated static variables.
    private static let _state = SharedState()
    
    private init() {}
    
    // MARK: - Configuration
    
    /// One-time configuration method. Should be called at app launch (AppDelegate/SceneDelegate).
    public static func configure(
        network: NetworkTransport,
        storage: StorageTransport? = nil,
        listener: NetworkErrorListener? = nil
    ) {
        // Synchronously update local state (Thread-safe write)
        _state.update(network: network, storage: storage)
        
        Task {
            await TransportRegistry.shared.configure(
                network: network,
                storage: storage,
                listener: listener
            )
        }
    }
    
    // MARK: - Helper Types
    
    /// Encapsulates mutable static state with a lock to satisfy Swift 6 / SPM Strict Concurrency.
    private final class SharedState: @unchecked Sendable {
        private let lock = NSLock()
        private var _network: NetworkTransport?
        private var _storage: StorageTransport?
        
        var network: NetworkTransport? {
            lock.lock()
            defer { lock.unlock() }
            return _network
        }
        
        var storage: StorageTransport? {
            lock.lock()
            defer { lock.unlock() }
            return _storage
        }
        
        func update(network: NetworkTransport, storage: StorageTransport?) {
            lock.lock()
            defer { lock.unlock() }
            _network = network
            _storage = storage
        }
    }
    
    // MARK: - Safe Fallback
    
    /// A fallback transport used when the manager is accessed before configuration.
    private struct UnconfiguredTransport: NetworkTransport {
        func request(path: String, method: HTTPMethod, body: RequestBody?, headers: [String : String]?) async throws -> NetworkResponse {
            print("⚠️ [NetworkManager] Error: Network layer used before configuration.")
            // Ensure this error type exists in your project
            throw TypedBackendError<String>.configurationMissing
        }
    }
}
