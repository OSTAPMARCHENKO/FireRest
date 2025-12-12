import Foundation
import FireRest

struct UpdateUserProfile: Request {
    typealias ResponseObjectType = UserProfileModel // Expect updated object back
    typealias ErrorType = ApiError
    
    let userId: String
    let params: UpdateUserProfileReqeustModel
    
    var path: String { "users/\(userId)" }
    var method: HTTPMethod { .patch }
    
    var body: RequestBody? {
        .params(params)
    }
}
