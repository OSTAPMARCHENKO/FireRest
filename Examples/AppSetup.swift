import SwiftUI
import FireRest
// import FirebaseCore // Uncomment if using Firebase
// import FirebaseFirestore

@main
struct MyApp: App {
    
    init() {
        setupNetworking()
    }
    
    private func setupNetworking() {
        // --- OPTION A: REST API ---
        // Perfect for standard backends like Node.js, Django, Vapor, etc.
        
        let apiBaseURL = URL(string: "https://api.myapp.com/v1")!
        let restTransport = URLSessionTransport(baseURL: apiBaseURL)
        
        // Configure only network (storage is optional)
        NetworkManager.configure(network: restTransport)
        
        
        // --- OPTION B: FIREBASE ---
        // Uncomment below to switch to Firebase without changing any other code in the app.
        
        /*
        FirebaseApp.configure()
        
        let dbTransport = FirebaseFirestoreTransport()
        let storageTransport = FirebaseStorageTransport()
        
        NetworkManager.configure(network: dbTransport, storage: storageTransport)
        */
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
