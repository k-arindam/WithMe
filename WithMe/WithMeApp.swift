//
//  WithMeApp.swift
//  WithMe
//
//  Created by Arindam Karmakar on 03/07/25.
//

import SwiftUI

@main
struct WithMeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    private let dataController: WMDataController
    private let authController: WMAuthController
    
    init() {
        let payload = WMAppInitializer.shared.start()
        
        self.dataController = payload.data
        self.authController = payload.auth
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .environmentObject(dataController)
                .environmentObject(authController)
        }
    }
}
