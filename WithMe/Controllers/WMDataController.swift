//
//  WMDataController.swift
//  WithMe
//
//  Created by Arindam Karmakar on 04/07/25.
//

import Foundation
import UIKit

internal final class WMDataController: ObservableObject, @unchecked Sendable {
    internal init() {}
    
    @Published var image = UIImage()
    
    let fileManager = FileManager.default
    let supportDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    
    internal func handle(image data: Data) async -> Void {
        guard let uiimage = UIImage(data: data) else { return }
    }
    
    private func save(image: UIImage, with id: UUID) -> Void {
        guard let imageData = image.jpegData(compressionQuality: 1) else { return }
        
        let fileName = id.uuidString + ".jpg"
        let fileURL = generateURL(for: fileName, at: .image)
        
        fileManager.createFile(atPath: fileURL.path(), contents: imageData)
    }
    
    private func generateURL(for name: String, at store: WMMediaStore) -> URL {
        supportDir.appendingPathComponent(store.rawValue + "/" + name)
    }
}

enum WMMediaStore: String, Sendable, CaseIterable {
    case image = "ImageStore"
    case document = "DocumentStore"
}

struct WMEntity: Codable, Identifiable, Sendable, Hashable {
    let id: UUID
    let url: URL
    let type: WMEntityType
}

enum WMEntityType: Codable, Sendable, CaseIterable {
    case image
    case document
}
