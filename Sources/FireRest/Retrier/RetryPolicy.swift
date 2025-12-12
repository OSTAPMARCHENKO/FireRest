//
//  RetyPolicy.swift
//
//  Created by Ostap Marchenko on 07.12.2025.
//

import Foundation

/// Retry logic configuration.
public struct RetryPolicy: Sendable {
    public let maxAttempts: Int
    public let baseDelay: TimeInterval
    
    public static let none = RetryPolicy(maxAttempts: 1, baseDelay: 0)
    public static let `default` = RetryPolicy(maxAttempts: 3, baseDelay: 0.5)
}
