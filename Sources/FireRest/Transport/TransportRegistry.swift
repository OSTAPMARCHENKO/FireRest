//
//  TransportRegistry.swift
//
//  Created by Ostap Marchenko on 07.12.2025.
//

import Foundation

/// Thread-safe registry to hold the current active transport.
public actor TransportRegistry {
    public static let shared = TransportRegistry()
    
    private var network: NetworkTransport?
    private var storage: StorageTransport?
    
    // Configurable error listener
    public var errorListener: NetworkErrorListener?
    
    private init() {}
    
    /// Configure the networking layer. Call this at app launch.
    public func configure(network: NetworkTransport, storage: StorageTransport? = nil, listener: NetworkErrorListener? = nil) {
        self.network = network
        self.storage = storage
        self.errorListener = listener
    }
    
    /// Accessors
    public func getNetwork() -> NetworkTransport {
        guard let network = network else {
            fatalError("CoreNetworking: NetworkTransport not configured. Call TransportRegistry.shared.configure(...) first.")
        }
        
        return network
    }
    
    public func getStorage() -> StorageTransport? {
        storage
    }
}
