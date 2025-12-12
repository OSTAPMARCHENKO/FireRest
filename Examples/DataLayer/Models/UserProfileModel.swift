import Foundation

struct UserProfileModel: Codable, Sendable {
    let id: String
    let name: String
    let email: String
    let avatarUrl: String?
}
