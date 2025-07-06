//
//  WMEngine.swift
//  WithMe
//
//  Created by Arindam Karmakar on 05/07/25.
//

import UIKit
import Vision

internal final class WMEngine {
    internal init() { self.loadModels() }
    
    let engineQueue: DispatchQueue = .init(label: "in.karindam.WithMe.WMEngineQueue", qos: .background)
    
    var embedderText: ClipText? = nil
    var embedderVision: ClipVision? = nil
    var captioner: BLIPImageCaptioning? = nil
    
    var mlConfig: MLModelConfiguration {
        let config = MLModelConfiguration()
        config.allowLowPrecisionAccumulationOnGPU = true
        config.computeUnits = .all
        return config
    }
    
    private func loadModels() -> Void {
        self.engineQueue.async {
            do {
                try self.loadEmbedder()
                try self.loadCaptioner()
            } catch {
                debugPrint("----->>> WMEngine.loadModels() Error: \(error)")
            }
        }
    }
    
    internal func process(image: UIImage) -> Void {
        guard let cgImage = image.cgImage else { return }
        
        self.ocr(cgImage) { _ in }
    }
}
