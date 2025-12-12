import Foundation

struct APIError: Codable, Sendable, Error {
    let code: Int
    let message: String
}
