//
//  FirebaseStorageTransport.swift
//
//  Created by Ostap Marchenko on 07.12.2025.
//

import Foundation
import FirebaseStorage

/// Firebase implementation of the `StorageTransport` protocol.
public final class FirebaseStorageTransport: StorageTransport, @unchecked Sendable {
    
    // MARK: - Constants
    
    private enum Constants {
        /// Default maximum size for downloads (10 MB).
        static let defaultMaxDownloadSize: Int64 = 10 * 1024 * 1024
        static let errorDomain = "FirebaseStorageTransport"
        static let unknownErrorCode = -1
    }
    
    // MARK: - Properties
    
    private var baseRef: StorageReference {
        return Storage.storage().reference()
    }
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - StorageTransport
    
    public func upload(data: Data, path: String) async throws -> URL {
        try await withCheckedThrowingContinuation { continuation in
            let ref = baseRef.child(path)
            
            ref.putData(data, metadata: nil) { _, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                ref.downloadURL { url, error in
                    if let url = url {
                        continuation.resume(returning: url)
                    } else {
                        continuation.resume(throwing: error ?? Self.makeUnknownError(msg: "Failed to retrieve download URL"))
                    }
                }
            }
        }
    }
    
    public func download(path: String) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            let ref = baseRef.child(path)
            
            ref.getData(maxSize: Constants.defaultMaxDownloadSize) { data, error in
                if let data = data {
                    continuation.resume(returning: data)
                } else {
                    continuation.resume(throwing: error ?? Self.makeUnknownError(msg: "Download failed"))
                }
            }
        }
    }
    
    public func delete(path: String) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            let ref = baseRef.child(path)
            
            ref.delete { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
    
    // MARK: - Private Helpers
    
    private static func makeUnknownError(msg: String) -> NSError {
        return NSError(
            domain: Constants.errorDomain,
            code: Constants.unknownErrorCode,
            userInfo: [NSLocalizedDescriptionKey: msg]
        )
    }
}
