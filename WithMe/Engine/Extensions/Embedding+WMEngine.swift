//
//  Embedding+WMEngine.swift
//  WithMe
//
//  Created by Arindam Karmakar on 05/07/25.
//

import UIKit
import CoreML
import MLXKit

internal extension WMEngine {
    func loadEmbedder() throws -> Void {
        let config = self.mlConfig
        
        self.embedderText = try ClipText(configuration: config)
        debugPrint("----->>> Loaded Text Embedder")
        self.embedderVision = try ClipVision(configuration: config)
        debugPrint("----->>> Loaded Vision Embedder")
    }
    
    func embedding(image: CGImage) -> Embedding {
        guard let embedderVision else { return [] }
        
        do {
            let input = try ClipVisionInput(input_imageWith: image)
            let output = try embedderVision.prediction(input: input)
            
            return output.feature.floatArray
        } catch {
            debugPrint("----->>> embedding(image:) Error: \(error)")
            return []
        }
    }
    
    func embedding(text: String) -> Embedding { [] }
}
