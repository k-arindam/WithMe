//
//  WMDataController.swift
//  WithMe
//
//  Created by Arindam Karmakar on 04/07/25.
//

import Foundation
import UIKit

internal final class WMDataController: ObservableObject, @unchecked Sendable {
    internal init() {}
    
    @MainActor @Published var image = UIImage()
    
    internal func handle(image data: Data) async -> Void {
        if let uiimage = UIImage(data: data) {
            await MainActor.run {
                self.image = uiimage
            }
        }
    }
}
