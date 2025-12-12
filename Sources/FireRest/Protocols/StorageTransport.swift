//
//  StorageTransport.swift
//
//  Created by Ostap Marchenko on 07.12.2025.
//

import Foundation

/// Responsible for file storage operations.
public protocol StorageTransport: Sendable {
    func upload(data: Data, path: String) async throws -> URL
    func download(path: String) async throws -> Data
    func delete(path: String) async throws
}
