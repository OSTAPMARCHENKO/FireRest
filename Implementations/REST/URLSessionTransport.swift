//
//  URLSessionTransport.swift
//
//  Created by Ostap Marchenko on 07.12.2025.
//

import Foundation

/// Standard REST API Transport using URLSession.
/// Returns a `NetworkResponse` allowing the upper layer to handle HTTP status codes.
public final class URLSessionTransport: NetworkTransport {
    
    // MARK: - Constants
    
    private enum Constants {
        static let contentTypeHeader = "Content-Type"
        static let acceptHeader = "Accept"
        static let applicationJson = "application/json"
    }
    
    // MARK: - Properties
    
    private let session: URLSession
    private let baseURL: URL
    
    // MARK: - Init
    
    public init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }
    
    // MARK: - NetworkTransport
    
    public func request(
        path: String,
        method: HTTPMethod,
        body: RequestBody?,
        headers: [String: String]?
    ) async throws -> NetworkResponse {
        
        let urlRequest = try buildURLRequest(path: path, method: method, body: body, headers: headers)
        
        let (data, response) = try await session.data(for: urlRequest)
        
        return try processResponse(data: data, response: response)
    }
    
    // MARK: - Private Helpers
    
    private func buildURLRequest(
        path: String,
        method: HTTPMethod,
        body: RequestBody?,
        headers: [String: String]?
    ) throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // 1. Set Default Headers
        request.setValue(Constants.applicationJson, forHTTPHeaderField: Constants.contentTypeHeader)
        request.setValue(Constants.applicationJson, forHTTPHeaderField: Constants.acceptHeader)
        
        // 2. Apply Custom Headers
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // 3. Encode Body
        if let body = body {
            request.httpBody = try body.encode()
        }
        
        return request
    }
    
    private func processResponse(data: Data, response: URLResponse) throws -> NetworkResponse {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        // Convert headers safely
        var responseHeaders: [String: String] = [:]
        for (key, value) in httpResponse.allHeaderFields {
            if let keyString = key as? String, let valueString = value as? String {
                responseHeaders[keyString] = valueString
            }
        }
        
        return NetworkResponse(
            data: data,
            statusCode: httpResponse.statusCode,
            headers: responseHeaders
        )
    }
}
