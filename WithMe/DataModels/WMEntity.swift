//
//  WMEntity.swift
//  WithMe
//
//  Created by Arindam Karmakar on 05/07/25.
//

import UIKit
import Foundation

internal struct WMEntity: Portable {
    init(image: Data, indexRef: UInt64, ocrData: OCRData? = nil, caption: Caption? = nil) {
        let id = UUID()
        let type = WMEntityType.image
        let store = type.store
        
        let fileName = Self.fileName(type: type, id: id)
        let fileURL = store.rawValue + "/" + fileName
        
        let thumbnailName = type.rawValue + "-thumbnail-" + id.uuidString + ".jpg"
        let thumbnailURL = store.rawValue + "/" + thumbnailName
        
        self.id = id
        self.indexRef = indexRef
        
        self.timestamp = .now
        
        self.ocrData = ocrData ?? OCRData()
        self.caption = caption ?? Caption()
        
        self.url = fileURL
        self.thumbnailURL = thumbnailURL
        
        self.persistedData = nil
        
        self.type = type
        
        self.temporaryData = image
    }
    
    let id: UUID
    let indexRef: UInt64
    
    let timestamp: Date
    
    let ocrData: OCRData
    let caption: Caption
    
    let url: String?
    let thumbnailURL: String?
    
    let persistedData: Data?
    
    let type: WMEntityType
    
    private var temporaryData: Data?
    
    var fileName: String {
        Self.fileName(type: self.type, id: self.id)
    }
    
    var fullURL: URL? {
        if let url {
            return WMUtils.generateURL(lastComponent: url)
        }
        
        return nil
    }
    
    var fullThumbnailURL: URL? {
        if let thumbnailURL {
            return WMUtils.generateURL(lastComponent: thumbnailURL)
        }
        
        return nil
    }
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case indexRef
        case timestamp
        case ocrData
        case caption
        case url
        case thumbnailURL
        case persistedData
        case type
    }
    
    func write() -> CGImage? {
        guard let fullURL,
              let fullThumbnailURL,
              let temporaryData,
              let image = UIImage(data: temporaryData),
              let thumbnailImage = image.cropToSquare(size: .init(width: 128, height: 128)),
              let imageData = image.jpegData(compressionQuality: 1.0),
              let thumbnailImagedata = thumbnailImage.jpegData(compressionQuality: 0.7)
        else { return nil }
        
        try? imageData.write(to: fullURL)
        try? thumbnailImagedata.write(to: fullThumbnailURL)
        
        return image.cgImage
    }
    
    private static func fileName(type: WMEntityType, id: UUID) -> String {
        type.rawValue + id.uuidString + ".jpg"
    }
}
