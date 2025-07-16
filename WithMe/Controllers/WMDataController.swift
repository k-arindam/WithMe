//
//  WMDataController.swift
//  WithMe
//
//  Created by Arindam Karmakar on 04/07/25.
//

import Foundation
import UIKit

internal final class WMDataController: ObservableObject, @unchecked Sendable {
    internal init(with db: WMDatabaseService) {
        self.engine = WMEngine()
        self.db = db
        self.prepare()
    }
    
    @Published private var _busy: Bool = false
    @Published internal private(set) var userData = [WMEntity]()
    @Published internal private(set) var messages = [WMMessage]()
    @Published internal private(set) var inferMode: WMInferMode = .edge
    @Published internal var responseMode: WMResponseMode = .searchOnly
    
    private let engine: WMEngine
    private let db: WMDatabaseService
    private let mainQueue = DispatchQueue.main
    private let dataQueue = DispatchQueue(label: "in.karindam.WithMe.WMDataControllerQueue", qos: .userInitiated)
    
    internal var edgeAI: Bool {
        get {
            inferMode == .edge
        }
        set {
            inferMode = newValue ? .edge : .remote
        }
    }
    
    internal var busy: Bool {
        get { _busy }
        set {
            mainQueue.async {
                self._busy = newValue
            }
        }
    }
    
    private var files: [URL] { userData.compactMap({ $0.fullURL }) }
    
    internal func submit(input: String) -> Void {
        guard !input.isEmpty, !busy else { return }
        
        let query = input.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let message = WMMessage(
            id: UUID(),
            content: .text(data: query),
            sender: .user
        )
        
        self.messages.append(message)
        self.busy = true
        
        self.dataQueue.async {
            if let queryVector = try? self.engine.embedding(text: query),
               let matchingKeys = try? self.engine.search(for: queryVector) {
                let matchingEntities = self.userData.filter { matchingKeys.contains($0.indexRef) }
                
                self.engine.prompt(with: matchingEntities, for: query) { result in
                    var response = String()
                    
                    switch result {
                    case .success(let output):
                        response = output
                    default:
                        response = "Whoopsie-doodle! My brain did a cartwheel and landed nowhere, mind giving it another go?"
                    }
                    
                    var messages = [WMMessage]()
                    
                    for entity in matchingEntities {
                        if entity.type == .image {
                            //
                        }
                    }
                    
                    messages.append(WMMessage(
                        id: UUID(),
                        content: .text(data: response),
                        sender: .assistant
                    ))
                    
                    self.mainQueue.async {
                        self.messages.append(contentsOf: messages)
                    }
                    
                    self.busy = false
                }
                
                return
            }
            
            self.busy = false
        }
    }
    
    internal func handle(image data: Data) async -> Void {
        guard let uiImage = UIImage(data: data), let cgImage = uiImage.cgImage else { return }
        
        let indexRef = UInt64(self.userData.count + 1)
        
        self.engine.ocr(cgImage) { ocrData in
            self.dataQueue.async {
                let entity = WMEntity(
                    image: data,
                    indexRef: indexRef,
                    ocrData: ocrData,
                    caption: ""
                )
                
                guard let entityImage = entity.write() else { return }
                
                do {
                    let vector = try self.engine.embedding(image: entityImage)
                    debugPrint("----->>> Vector: \(vector.count)")
                    
                    if !vector.isEmpty {
                        try self.engine.insert(vector: vector, at: indexRef)
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
        
        self.dataQueue.async {
            self.engine.prepare()
        }
    }
    
    private func insertUserData(_ entity: WMEntity) -> Void {
        DispatchQueue.main.async {
            self.userData.append(entity)
            self.db.updateUserData(with: self.userData)
        }
    }
}
