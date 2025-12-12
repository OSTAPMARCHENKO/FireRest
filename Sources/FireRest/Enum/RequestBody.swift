//
//  RequestBody.swift
//
//  Created by Ostap Marchenko on 07.12.2025.
//

import Foundation

public enum RequestBody: Sendable {
    case params(Encodable & Sendable)
    case json(Data)
    
    public func encode() throws -> Data {
        switch self {
        case .params(let model):
            return try JSONEncoder().encode(model)
            
        case .json(let data):
            return data
        }
    }
}
