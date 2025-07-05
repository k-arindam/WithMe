//
//  WMEngine.swift
//  WithMe
//
//  Created by Arindam Karmakar on 05/07/25.
//

import UIKit
import Vision



struct WMImageEntityContext: Portable {
    let id: UUID
    let image: Data
    let ocrData: OCRData
    let caption: Caption
    let embedding: Embedding
}

internal final class WMEngine {
    internal init() {}
    
    internal func process(image: UIImage) -> Void {
        guard let cgImage = image.cgImage else { return }
        
        self.ocr(cgImage)
    }
}
