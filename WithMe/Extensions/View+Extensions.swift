//
//  View+Extensions.swift
//  WithMe
//
//  Created by Arindam Karmakar on 13/07/25.
//

import SwiftUI

internal extension View {
    func glassEffectWithFallback(in shape: any Shape) -> AnyView {
        if #available(iOS 26.0, *) {
            if let shape = shape as? DefaultGlassEffectShape {
                return AnyView(glassEffect(in: shape))
            }
        }
        
        return AnyView(self)
    }
    
    func glassButtonStyleWithFallback<S>(_ style: S = .borderedProminent, prominent: Bool = false) -> AnyView where S: PrimitiveButtonStyle {
        if #available(iOS 26.0, *) {
            if prominent {
                return AnyView(buttonStyle(.glassProminent))
            } else {
                return AnyView(buttonStyle(.glass))
            }
        } else {
            return AnyView(buttonStyle(style))
        }
    }
}
