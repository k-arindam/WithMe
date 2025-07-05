//
//  WMEngine.swift
//  WithMe
//
//  Created by Arindam Karmakar on 05/07/25.
//

import UIKit
import Vision

internal final class WMEngine {
    internal init() {}
    
    internal func process(image: UIImage) -> Void {
        guard let cgImage = image.cgImage else { return }
        
        self.ocr(cgImage) { _ in }
    }
}
