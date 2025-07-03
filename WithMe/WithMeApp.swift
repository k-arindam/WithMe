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
    private let dataController: WMDataController
    
    init() {
        let dataController = WMDataController()
        AppDependencyManager.shared.add(key: Constants.dataControllerKey, dependency: dataController)
        self.dataController = dataController
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataController)
        }
    }
}
