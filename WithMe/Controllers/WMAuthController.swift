//
//  WMAuthController.swift
//  WithMe
//
//  Created by Arindam Karmakar on 05/07/25.
//

import FirebaseAuth

internal final class WMAuthController: ObservableObject {
    @Published var user: User? = nil
    
    func appleLogin() -> Void {}
}
