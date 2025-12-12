//
//  HTTPMethod.swift
//
//  Created by Ostap Marchenko on 07.12.2025.
//

import Foundation

/// HTTP methods used for requests.
public enum HTTPMethod: String, Sendable {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
    case patch = "PATCH"
}
