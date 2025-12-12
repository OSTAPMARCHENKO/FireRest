import Foundation
import FireRest

struct GetUserProfile: Request {
    typealias ResponseObjectType = UserProfileModel
    typealias ErrorType = APIError
    
    let userId: String
    
    // REST: GET /users/{userId}
    // Firebase: db.collection("users").document(userId).getDocument()
    var path: String {
        "users/\(userId)"
    }
    
    var method: HTTPMethod { .get }
}
