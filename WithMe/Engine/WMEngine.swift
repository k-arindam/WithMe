//
//  WMEngine.swift
//  WithMe
//
//  Created by Arindam Karmakar on 05/07/25.
//

import UIKit
import UForm
import USearch
import CoreML
import LocalLLMClientLlama

internal final class WMEngine {
    internal init() {}
    
    let foundationBackend: Bool = false
    let engineQueue: DispatchQueue = .init(label: "in.karindam.WithMe.WMEngineQueue", qos: .userInitiated)
    
    var embedderText: TextEncoder? = nil
    var embedderImage: ImageEncoder? = nil
    
    var index: USearchIndex? = nil
    
    var llmClient: LlamaClient? = nil
    
    var llmAvailable: Bool = false
        
    var mlConfig: MLModelConfiguration {
        let config = MLModelConfiguration()
        config.allowLowPrecisionAccumulationOnGPU = true
        config.computeUnits = .all
        return config
    }
    
    var indexURL: URL {
        let fileName = "index.usearch"
        return WMUtils.generateURL(for: fileName, at: .index)
    }
    
    internal func prepare() -> Void {
        do {
            try self.loadEmbedder()
            try self.initLLM()
            try self.loadCaptioner()
        } catch {
            debugPrint("----->>> WMEngine.loadModels() Error: \(error)")
        }
    }
}
