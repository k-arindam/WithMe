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
    var mlConfig: MLModelConfiguration {
        let config = MLModelConfiguration()
        config.allowLowPrecisionAccumulationOnGPU = true
        config.computeUnits = .all
        return config
    }
    
    func embedding(image: CGImage) -> Embedding {
        do {
            let model = try ClipVision(configuration: mlConfig)
            let input = try ClipVisionInput(input_imageWith: image)
            let output = try model.prediction(input: input)
            
            return output.feature.floatArray
        } catch {
            debugPrint("----->>> embedding(image:) Error: \(error)")
            return []
        }
    }
    
    func embedding(text: String) -> Embedding { [] }
}
