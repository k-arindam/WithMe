//
//  UIImage+Extensions.swift
//  WithMe
//
//  Created by Arindam Karmakar on 07/07/25.
//

import UIKit

internal extension UIImage {
    func cropToSquare(size: CGSize = CGSize(width: 256, height: 256)) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        
        let originalWidth = cgImage.width
        let originalHeight = cgImage.height
        
        // Calculate the square size (minimum of width and height)
        let squareSize = min(originalWidth, originalHeight)
        
        // Calculate the crop origin to center the square
        let x = (originalWidth - squareSize) / 2
        let y = (originalHeight - squareSize) / 2
        
        // Create crop rectangle
        let cropRect = CGRect(x: x, y: y, width: squareSize, height: squareSize)
        
        // Crop the image
        guard let croppedCGImage = cgImage.cropping(to: cropRect) else { return nil }
        
        // Create UIImage from cropped CGImage
        let croppedImage = UIImage(cgImage: croppedCGImage)
        
        // Resize to desired size (256x256)
        return croppedImage.resized(to: size)
    }
    
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
