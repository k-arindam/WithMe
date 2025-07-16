//
//  WMResponseMode.swift
//  WithMe
//
//  Created by Arindam Karmakar on 16/07/25.
//

import Foundation

internal enum WMResponseMode: String, Portable, CaseIterable {
    var id: String { rawValue }
    
    case searchOnly = "Search Only"
    case searchAndGenerate = "Search & Generate"
}
