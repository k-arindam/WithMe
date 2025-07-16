//
//  Scaffold.swift
//  WithMe
//
//  Created by Arindam Karmakar on 06/07/25.
//

import SwiftUI

struct Scaffold: View {
    init(enableBackground: Bool = false, child: @escaping () -> any View) {
        self.enableBackground = enableBackground
        self.child = child
    }
    
    let enableBackground: Bool
    @ViewBuilder let child: () -> any View
    
    var body: some View {
        ZStack {
            if enableBackground {
                Image(.background001)
                    .resizable()
                    .opacity(0.5)
                    .ignoresSafeArea()
            }
            
            AnyView(child())
        }
    }
}

#Preview {
    Scaffold { Text("Scaffold") }
}
