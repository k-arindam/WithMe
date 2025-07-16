//
//  WMDefaults.swift
//  WithMe
//
//  Created by Arindam Karmakar on 05/07/25.
//

import Foundation

internal final class WMDefaults {
    private init() {}
    
    private static let defaults = UserDefaults.standard
    private static let userDataKey = "in.karindam.WithMe.userData"
    private static let setupFinishedKey = "in.karindam.WithMe.setupFinished"
    
    static var setupFinished: Bool {
        let value = defaults.bool(forKey: setupFinishedKey)
        if !value { defaults.set(true, forKey: setupFinishedKey) }
        return value
    }
    
    static var userData: Data? {
        get { defaults.data(forKey: userDataKey) }
        set { defaults.set(newValue, forKey: userDataKey) }
    }
}
