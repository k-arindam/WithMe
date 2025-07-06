//
//  VisualBlurEffect.swift
//  WithMe
//
//  Created by Arindam Karmakar on 06/07/25.
//

import SwiftUI

struct VisualBlurEffect: UIViewRepresentable {
    let blurStyle: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> some UIView {
        UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
