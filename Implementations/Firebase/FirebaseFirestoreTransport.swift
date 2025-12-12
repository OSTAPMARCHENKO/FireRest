//
//  FirebaseDatabaseTransport.swift
//
//  Created by Ostap Marchenko on 07.12.2025.
//

import Foundation
@preconcurrency import FirebaseFirestore

/// A Firebase-backed implementation of the `NetworkTransport` protocol using Cloud Firestore.
public final class FirebaseFirestoreTransport: NetworkTransport, Sendable {
    
    // MARK: - Transport Error
    
    public enum TransportError: Error, LocalizedError {
        case invalidPath(String)
        case invalidJSONFormat
        case missingData
        
        public var errorDescription: String? {
            switch self {
            case .invalidPath(let path):
                return "The path '\(path)' is invalid. Firestore document paths must have an even number of segments."
            case .invalidJSONFormat:
                return "Firestore data must be a JSON Object (Dictionary)."
            case .missingData:
                return "The request body is missing."
            }
        }
    }
    
    // MARK: - Constants
    
    private enum Constants {
        static let pathSeparator: Character = "/"
        static let successStatusCode = 200
        static let noContentStatusCode = 204
        static let notFoundStatusCode = 404
    }
    
    // MARK: - Properties
    
    private let rootPath: String
    private let db: Firestore
    
    // MARK: - Init
    
    public init(rootPath: String = "") {
        self.rootPath = rootPath
        self.db = Firestore.firestore()
    }
    
    // MARK: - NetworkTransport
    
    public func request(
        path: String,
        method: HTTPMethod,
        body: RequestBody?,
        headers: [String : String]?
    ) async throws -> NetworkResponse {
        
        let docRef = try getDocumentReference(for: path)
        
        switch method {
        case .get:
            return try await performGet(docRef: docRef)
            
        case .put, .post:
            return try await performWrite(docRef: docRef, body: body, merge: false)
            
        case .patch:
            return try await performWrite(docRef: docRef, body: body, merge: true)
            
        case .delete:
            return try await performDelete(docRef: docRef)
        }
    }

    // MARK: - Private Helpers (Logic)

    /// Validates path and returns a DocumentReference
    private func getDocumentReference(for path: String) throws -> DocumentReference {
        let fullPath = rootPath.isEmpty ? path : "\(rootPath)/\(path)"
        let segments = fullPath.split(separator: Constants.pathSeparator)
        
        // Validate: Must point to a Document (even segments)
        guard !segments.isEmpty, segments.count % 2 == 0 else {
            throw TransportError.invalidPath(fullPath)
        }
        
        return db.document(fullPath)
    }

    // MARK: - CRUD Operations

    private func performGet(docRef: DocumentReference) async throws -> NetworkResponse {
        let snapshot = try await docRef.getDocument()
        
        if snapshot.exists, let dataDict = snapshot.data() {
            let jsonData = try JSONHelpers.serialize(dict: dataDict)
            return NetworkResponse(data: jsonData, statusCode: Constants.successStatusCode)
        } else {
            return NetworkResponse(data: Data(), statusCode: Constants.notFoundStatusCode)
        }
    }

    private func performWrite(docRef: DocumentReference, body: RequestBody?, merge: Bool) async throws -> NetworkResponse {
        guard let body = body else { throw TransportError.missingData }
        let data = try body.encode()
        
        let validDict = try JSONHelpers.deserializeToDict(data: data)
        try await docRef.setData(validDict, merge: merge)
        
        return NetworkResponse(data: data, statusCode: Constants.successStatusCode)
    }

    private func performDelete(docRef: DocumentReference) async throws -> NetworkResponse {
        try await docRef.delete()
        return NetworkResponse(data: Data(), statusCode: Constants.noContentStatusCode)
    }
}

// MARK: - JSON Helpers
/// Private namespace for JSON logic to keep the main class clean
private enum JSONHelpers {
    static func serialize(dict: [String: Any]) throws -> Data {
        try JSONSerialization.data(withJSONObject: dict)
    }
    
    static func deserializeToDict(data: Data) throws -> [String: Any] {
        let jsonObject = try JSONSerialization.jsonObject(with: data)
        guard let validDict = jsonObject as? [String: Any] else {
            throw FirebaseFirestoreTransport.TransportError.invalidJSONFormat
        }
        return validDict
    }
}
