//
//  WMShortcutService.swift
//  WithMe
//
//  Created by Arindam Karmakar on 04/07/25.
//

import UIKit
import UniformTypeIdentifiers

internal final class WMShortcutService {
    private let type: UTType = UTType(filenameExtension: "shortcut")!
    
    @MainActor
    internal func add(shortcut: WMShortcut, from target: WMShortcutTarget = .remote) async -> Bool {
        let bundle = Bundle.main
        let app = UIApplication.shared
        
        var url: URL? = nil
        
        switch target {
        case .asset:
            url = bundle.url(forResource: shortcut.rawValue, withExtension: "shortcut")
        case .remote:
            url = shortcut.remoteURL
        }
        
        if let url, app.canOpenURL(url) {
            await app.open(url)
            return true
        }
        
        return false
    }
}

enum WMShortcutTarget: Sendable, CaseIterable {
    case asset
    case remote
}
