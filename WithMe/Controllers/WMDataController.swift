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
    }
    
    @Published private(set) var userData: [WMEntity] = []
    
    let db = WMDatabaseService()
    let fileManager = FileManager.default
    
    internal func handle(image data: Data) async -> Void {
        guard let uiimage = UIImage(data: data),
              let jpegData = uiimage.jpegData(compressionQuality: 1.0)
        else { return }
        
        let entity = WMEntity(jpeg: jpegData)
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
