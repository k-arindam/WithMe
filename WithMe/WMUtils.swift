//
//  WMUtils.swift
//  WithMe
//
//  Created by Arindam Karmakar on 05/07/25.
//

import UIKit
import Foundation

internal final class WMUtils {
    private init() {}
    
    static let fileManager = FileManager.default
    static let documentDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static var rootViewController: UIViewController? {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = scene.windows.first?.rootViewController{
            return rootVC
        }
        
        return nil
    }
    
    static func createDirectories() -> Void {
        for store in WMMediaStore.allCases {
            let dir = documentDir.appendingPathComponent(store.rawValue)
            
            if !exists(at: dir) {
                try? fileManager.createDirectory(at: dir, withIntermediateDirectories: true)
            }
        }
    }
    
    static func generateURL(lastComponent: String) -> URL {
        documentDir.appendingPathComponent(lastComponent)
    }
    
    static func generateURL(for name: String, at store: WMMediaStore) -> URL {
        documentDir.appendingPathComponent(store.rawValue + "/" + name)
    }
    
    static func exists(at url: URL) -> Bool {
        fileManager.fileExists(atPath: url.path())
    }
}
