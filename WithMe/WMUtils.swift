//
//  WMUtils.swift
//  WithMe
//
//  Created by Arindam Karmakar on 05/07/25.
//

import UIKit
import Foundation
import ZIPFoundation

internal final class WMUtils {
    private init() {}
    
    static let bundle = Bundle.main
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
    
    static func copyResources() -> Void {
        let textEncoderSourceURL = bundle.url(forResource: "text_encoder.mlpackage", withExtension: "zip")!
        let textEncourcerDestinationURL = generateURL(for: "text_encoder.mlpackage.zip", at: .model)
        
        let imageEncoderSourceURL = bundle.url(forResource: "image_encoder.mlpackage", withExtension: "zip")!
        let imageEncourcerDestinationURL = generateURL(for: "image_encoder.mlpackage.zip", at: .model)
        
        do {
            if !exists(at: textEncourcerDestinationURL) {
                try fileManager.copyItem(
                    at: textEncoderSourceURL,
                    to: textEncourcerDestinationURL
                )
                try fileManager.unzipItem(
                    at: textEncourcerDestinationURL,
                    to: textEncourcerDestinationURL.deletingLastPathComponent()
                )
                
                debugPrint("----->>> copyResources() Success: text_encoder.mlpackage")
            }
            
            if !exists(at: imageEncourcerDestinationURL) {
                try fileManager.copyItem(
                    at: imageEncoderSourceURL,
                    to: imageEncourcerDestinationURL
                )
                try fileManager.unzipItem(
                    at: imageEncourcerDestinationURL,
                    to: imageEncourcerDestinationURL.deletingLastPathComponent()
                )
                
                debugPrint("----->>> copyResources() Success: image_encoder.mlpackage")
            }
        } catch {
            debugPrint("----->>> copyResources() Error: \(error)")
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
    
    static func fetchAppVersion() -> String {
        if let info = bundle.infoDictionary,
           let version = info["CFBundleShortVersionString"] as? String {
            return version
        }
        
        return String()
    }
}
