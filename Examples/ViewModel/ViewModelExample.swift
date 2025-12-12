import SwiftUI
import FireRest

@MainActor
class ProfileViewModel: ObservableObject {
    
    @Published var user: UserProfile?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - Network Request
    
    func loadUser(id: String) async {
        self.isLoading = true
        self.errorMessage = nil
        
        do {
            // .execute() automatically uses the configured Transport (REST or Firebase)
            let fetchedUser = try await GetUserProfile(userId: id).execute()
            self.user = fetchedUser
            
        } catch let error as TypedBackendError<APIError> {
            // Handle typed errors
            switch error {
            case .backend(let apiError, let code):
                self.errorMessage = "Server Error (\(code)): \(apiError.message)"
            case .network(let netError):
                self.errorMessage = "Connection lost: \(netError.localizedDescription)"
            default:
                self.errorMessage = error.localizedDescription
            }
        } catch {
            self.errorMessage = "Unexpected error: \(error.localizedDescription)"
        }
        
        self.isLoading = false
    }
    
    // MARK: - Storage Example
    
    func uploadAvatar(data: Data) async {
        guard let userId = user?.id else { return }
        
        do {
            // Uses whatever storage is configured (Firebase Storage or Custom)
            let url = try await NetworkManager.storage.upload(
                data: data,
                path: "avatars/\(userId).jpg"
            )
            print("Avatar uploaded to: \(url)")
            
            // Optionally update the user profile with new URL
            // await updateProfilePhoto(url)
            
        } catch {
            self.errorMessage = "Failed to upload image: \(error.localizedDescription)"
        }
    }
}
