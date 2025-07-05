//
//  WMMediaStore.swift
//  WithMe
//
//  Created by Arindam Karmakar on 05/07/25.
//

import Foundation

enum WMMediaStore: String, Sendable, CaseIterable {
    case json = "WMJSONStore"
    case image = "WMImageStore"
    case document = "WMDocumentStore"
}
