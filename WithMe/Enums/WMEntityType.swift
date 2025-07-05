//
//  WMEntityType.swift
//  WithMe
//
//  Created by Arindam Karmakar on 05/07/25.
//

import Foundation

enum WMEntityType: String, Codable, Sendable, CaseIterable {
    case image = "WMImage"
    case document = "WMDocument"
    
    var store: WMMediaStore {
        switch self {
        case .image:
            return .image
        case .document:
            return .document
        }
    }
}
