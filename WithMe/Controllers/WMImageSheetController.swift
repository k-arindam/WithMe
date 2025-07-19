//
//  WMImageSheetController.swift
//  WithMe
//
//  Created by Arindam Karmakar on 19/07/25.
//

import UIKit
import Foundation

@MainActor internal final class WMImageSheetController: ObservableObject {
    @Published var data: WMImageSheetData? = nil
    
    @MainActor
    internal func present(with image: UIImage) -> Void {
        let id = UUID()
        let data = WMImageSheetData(
            id: id,
            image: image
        )
        
        self.data = data
    }
}
