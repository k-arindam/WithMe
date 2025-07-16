//
//  Embedding+WMEngine.swift
//  WithMe
//
//  Created by Arindam Karmakar on 05/07/25.
//

import UIKit
import CoreML
import MLXKit
import UForm
import USearch

internal extension WMEngine {
    func loadEmbedder() throws -> Void {
        let bundle = Bundle.main
        let configURL = bundle.url(forResource: "config", withExtension: "json")!
        let tokenizerURL = bundle.url(forResource: "tokenizer", withExtension: "json")!
        let textEncoderURL = WMUtils.generateURL(for: "text_encoder.mlpackage", at: .model)
        let imageEncoderURL = WMUtils.generateURL(for: "image_encoder.mlpackage", at: .model)
        
        self.embedderText = try TextEncoder(
            modelPath: textEncoderURL.path(),
            configPath: configURL.path(),
            tokenizerPath: tokenizerURL.path(),
            computeUnits: .all
        )
        debugPrint("----->>> Loaded Text Embedder !!!")
        
        self.embedderImage = try ImageEncoder(
            modelPath: imageEncoderURL.path(),
            configPath: configURL.path(),
            computeUnits: .all
        )
        debugPrint("----->>> Loaded Image Embedder !!!")
        
        self.initIndex()
        debugPrint("----->>> Loaded Index !!!")
    }
    
    func insert(vector: Vector, at pos: UInt64) throws -> Void {
        guard let index else { throw WMError.indexUnavailable }
        
        try index.reserve(UInt32(pos))
        try index.add(key: pos, vector: vector)
        
        try save(index: index)
        debugPrint("----->>> Inserted Vector !!!")
    }
    
    func embedding(image: CGImage) throws -> Vector {
        guard let embedderImage else { throw WMError.modelUnavailable }
        
        let embedding = try embedderImage.encode(image)
        return embedding.asFloats()
    }
    
    func embedding(text: String) throws -> Vector {
        guard let embedderText else { throw WMError.modelUnavailable }
        
        let embedding = try embedderText.encode(text)
        return embedding.asFloats()
    }
    
    func search(for vector: Vector) throws -> [USearchKey] {
        guard let index else { throw WMError.indexUnavailable }
        
        let result = try index.search(vector: vector, count: 3)
        return result.0
    }
    
    private func initIndex() -> Void {
        let indexURL = self.indexURL
        
        do {
            let index = try USearchIndex.make(
                metric: .cos,
                dimensions: 256,
                connectivity: 16,
                quantization: .f16
            )
            
            if WMUtils.exists(at: indexURL) {
                try index.load(path: indexURL.path())
            } else {
                try self.save(index: index)
            }
            
            self.index = index
        } catch {
            debugPrint("----->>> Error while initializing index: \(error)")
        }
    }
    
    private func save(index: USearchIndex) throws -> Void {
        try index.save(path: indexURL.path())
        debugPrint("----->>> Index saved successfully !!!")
    }
}
