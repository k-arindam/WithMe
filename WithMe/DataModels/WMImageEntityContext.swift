//
//  WMImageEntityContext.swift
//  WithMe
//
//  Created by Arindam Karmakar on 05/07/25.
//

import Foundation

struct WMImageEntityContext: Portable {
    let id: UUID
    let image: Data
    let ocrData: OCRData
    let caption: Caption
    let vector: Vector
}
