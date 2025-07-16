//
//  WMAuthController.swift
//  WithMe
//
//  Created by Arindam Karmakar on 05/07/25.
//

import FirebaseAuth

internal final class WMAuthController: ObservableObject {
    @Published var user: WMUser? = nil
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func appleLogin() -> Void {}
    
    @MainActor
    func makeLocalUser() -> WMUser {
        if let userData = WMDefaults.userData,
           let user = try? decoder.decode(WMUser.self, from: userData) {
            self.user = user
            return user
        }
        
        let newUser = WMUser(
            id: UUID(),
            name: WMConstants.anonymousUsernames.randomElement() ?? "Anonymous"
        )
        
        self.user = newUser
        self.syncUserData()
        
        return newUser
    }
    
    @MainActor
    func updateUserName(to name: String) -> Void {
        guard let user else { return }
        let newUser = user.copyWith(name: name)
        self.user = newUser
        self.syncUserData()
    }
    
    private func syncUserData() -> Void {
        guard let user, let userData = try? encoder.encode(user) else { return }
        WMDefaults.userData = userData
    }
}
