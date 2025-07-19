//
//  ImageSheet.swift
//  WithMe
//
//  Created by Arindam Karmakar on 19/07/25.
//

import SwiftUI

struct ImageSheet: View {
    init(@ViewBuilder child: @escaping () -> any View) {
        self.child = child
    }
    
    @ViewBuilder let child: () -> any View
    
    @StateObject private var controller = WMImageSheetController()
    
    let clipShape: RoundedRectangle = RoundedRectangle(cornerRadius: 12.0)
    
    var body: some View {
        VStack {
            AnyView(child())
        }
        .environmentObject(controller)
        .sheet(item: $controller.data) { data in
            Image(uiImage: data.image)
                .resizable()
                .scaledToFit()
                .clipShape(clipShape)
                .glassEffectWithFallback(in: clipShape)
                .padding(42.0)
        }
    }
}

#Preview {
    ImageSheet { }
}
