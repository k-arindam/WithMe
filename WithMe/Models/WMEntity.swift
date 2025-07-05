//
//  WMEntity.swift
//  WithMe
//
//  Created by Arindam Karmakar on 05/07/25.
//

import Foundation

internal struct WMEntity: Codable, Identifiable, Sendable, Hashable {
    init(jpeg: Data) {
        let id = UUID()
        let type = WMEntityType.image
        let store = type.store
        
        let fileName = type.rawValue + id.uuidString + ".jpg"
        let fileURL = store.rawValue + "/" + fileName
        
        self.id = id
        self.url = fileURL
        self.persistedData = nil
        self.type = type
        
        self.temporaryData = jpeg
    }
    
    let id: UUID
    let url: String?
    let persistedData: Data?
    let type: WMEntityType
    
    private var temporaryData: Data?
    
    var fullURL: URL? {
        if let url {
            return WMUtils.generateURL(lastComponent: url)
        }
        
        return nil
    }
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case url
        case persistedData
        case type
    }
    
    func write() -> Void {
        guard let fullURL, let temporaryData else { return }
        try! temporaryData.write(to: fullURL)
    }
}
