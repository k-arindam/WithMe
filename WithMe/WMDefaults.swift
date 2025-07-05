//
//  WMDefaults.swift
//  WithMe
//
//  Created by Arindam Karmakar on 05/07/25.
//

import Foundation

internal final class WMDefaults {
    private init() {}
    
    static let defaults = UserDefaults.standard
    
    static var setupFinished: Bool {
        let key = "in.karindam.WithMe.setupFinished"
        let value = defaults.bool(forKey: key)
        if !value { defaults.set(true, forKey: key) }
        return value
    }
    
    static var userID: String {
        let key = "in.karindam.WithMe.userID"
        guard let value = defaults.string(forKey: key) else {
            let newValue = UUID().uuidString
            defaults.set(newValue, forKey: key)
            return newValue
        }
        return value
    }
}
