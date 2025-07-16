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
        
        var url: URL!
        
        switch target {
        case .asset:
            url = bundle.url(forResource: shortcut.rawValue, withExtension: "shortcut")
        case .remote:
            url = shortcut.remoteURL
        }
        
        return await open(url: url)
    }
    
    @MainActor
    internal func run(shortcut: WMShortcut) async -> Bool {
        guard let url = URL(string: "shortcuts://run-shortcut?name=\(shortcut.rawValue)") else { return false }
        return await open(url: url)
    }
    
    @MainActor
    private func open(url: URL) async -> Bool {
        let app = UIApplication.shared
        
        if app.canOpenURL(url) {
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
