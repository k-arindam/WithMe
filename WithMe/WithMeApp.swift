//
//  WithMeApp.swift
//  WithMe
//
//  Created by Arindam Karmakar on 03/07/25.
//

import SwiftUI
import AppIntents

@main
struct WithMeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    private let dataController: WMDataController
    private let authController: WMAuthController
    
    init() {
        WMUtils.createDirectories()
        
        let dataController = WMDataController()
        AppDependencyManager.shared.add(key: WMConstants.dataControllerKey, dependency: dataController)
        
        self.dataController = dataController
        self.authController = WMAuthController()
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
