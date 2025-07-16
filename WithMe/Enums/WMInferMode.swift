//
//  WMInferMode.swift
//  WithMe
//
//  Created by Arindam Karmakar on 16/07/25.
//

import Foundation

enum WMInferMode: String, Portable, CaseIterable {
    var id: String { rawValue }
    
    case edge
    case remote
}
