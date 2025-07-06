//
//  WMDataController.swift
//  WithMe
//
//  Created by Arindam Karmakar on 04/07/25.
//

import Foundation
import UIKit

internal final class WMDataController: ObservableObject, @unchecked Sendable {
    internal init() {
        self.userData = db.fetchUserData()
        for e in userData {
            engine.process(image: UIImage(contentsOfFile: e.fullURL!.path())!)
        }
    }
    
    @Published private(set) var userData: [WMEntity] = []
    
    let engine = WMEngine()
    let db = WMDatabaseService()
    let fileManager = FileManager.default
    
    internal func handle(image data: Data) async -> Void {
        let entity = WMEntity(image: data)
        entity.write()
        
        self.insertUserData(entity)
    }
    
    private func insertUserData(_ entity: WMEntity) -> Void {
        DispatchQueue.main.async {
            self.userData.append(entity)
            self.db.updateUserData(with: self.userData)
        }
    }
}
