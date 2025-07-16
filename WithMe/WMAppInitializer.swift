//
//  WMAppInitializer.swift
//  WithMe
//
//  Created by nuuuron on 16/07/25.
//

import AppIntents
import AwesomeNavigation

internal final class WMAppInitializer {
    private init() {}
    internal static let shared = WMAppInitializer()
    
    @MainActor func start() -> (data: WMDataController, auth: WMAuthController) {
        WMUtils.createDirectories()
        WMUtils.copyResources()
        
        let _ = WMDefaults.setupFinished
        
        let authController = WMAuthController()
        let user = authController.makeLocalUser()
        
        let db = WMDatabaseService(with: user.id)
        let dataController = WMDataController(with: db)
        
        AppDependencyManager.shared.add(key: WMConstants.dataControllerKey, dependency: dataController)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            AwesomeNavigation.shared.pushReplacement(WMRoutes.home)
        }
        
        return (dataController, authController)
    }
}
