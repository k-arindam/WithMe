//
//  WMDataController.swift
//  WithMe
//
//  Created by Arindam Karmakar on 04/07/25.
//

import Foundation
import UIKit

internal final class WMDataController: ObservableObject, @unchecked Sendable {
    internal init() { self.prepare() }
    
    @Published internal private(set) var userData: [WMEntity] = []
    
    private let engine = WMEngine()
    private let db = WMDatabaseService()
    private let queue = DispatchQueue(label: "in.karindam.WithMe.WMDataControllerQueue", qos: .userInitiated)
    
    private var files: [URL] { userData.compactMap({ $0.fullURL }) }
    
    internal func handle(image data: Data) async -> Void {
        guard let uiImage = UIImage(data: data), let cgImage = uiImage.cgImage else { return }
        
        let indexRef = UInt64(self.userData.count + 1)
        
        self.engine.ocr(cgImage) { ocrData in
            self.queue.async {
                let entity = WMEntity(
                    image: data,
                    indexRef: indexRef,
                    ocrData: ocrData
                )
                
                guard let entityImage = entity.write() else { return }
                
                do {
                    let vector = try self.engine.embedding(image: entityImage)
                    debugPrint("----->>> Vector: \(vector.count)")
                    
                    if !vector.isEmpty {
    //                    try self.engine.insert(vector: vector, at: indexRef)
                        self.insertUserData(entity)
                    }
                } catch {
                    debugPrint("----->>> handle(image data: Data) Error: \(error)")
                }
            }
        }
    }
    
    private func prepare() -> Void {
        self.userData = db.fetchUserData()
        
        let _ = Task.detached {
            await self.engine.prepare()
            self.engine.prompt(with: [self.userData.first!], for: "Explain in details what you can see and understand from this images.")
        }
    }
    
    private func insertUserData(_ entity: WMEntity) -> Void {
        DispatchQueue.main.async {
            self.userData.append(entity)
            self.db.updateUserData(with: self.userData)
        }
    }
}
