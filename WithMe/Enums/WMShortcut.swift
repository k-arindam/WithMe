//
//  WMShortcut.swift
//  WithMe
//
//  Created by Arindam Karmakar on 04/07/25.
//

import Foundation

enum WMShortcut: String, Sendable, CaseIterable {
    case shareScreenShot = "Share Screenshot With Me"
    
    var remoteURL: URL? {
        switch self {
        case .shareScreenShot:
            return URL(string: "https://www.icloud.com/shortcuts/0fb0adfded4a45549d22dbb03e1cc425")
        }
    }
}
