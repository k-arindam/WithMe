//
//  OCR+WMEngine.swift
//  WithMe
//
//  Created by Arindam Karmakar on 05/07/25.
//

import Vision

internal extension WMEngine {
    func ocr(_ image: CGImage, completion: @Sendable @escaping (OCRData) -> Void) -> Void {
        let requestHandler = VNImageRequestHandler(cgImage: image)
        let request = VNRecognizeTextRequest { req, error in
            if error == nil, let results = req.results as? [VNRecognizedTextObservation] {
                let data = results.compactMap { $0.topCandidates(1).first?.string }
                completion(data as OCRData)
                return
            }
            
            completion([])
        }
        
        do {
            try requestHandler.perform([request])
        } catch {
            completion([])
        }
    }
}
