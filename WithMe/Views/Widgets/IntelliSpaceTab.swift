//
//  IntelliSpaceTab.swift
//  WithMe
//
//  Created by Arindam Karmakar on 15/07/25.
//

import SwiftUI

struct IntelliSpaceTab: View {
    let textfieldShape = Capsule()
    let shortcutService = WMShortcutService()
    
    @State private var input = String()
    
    var body: some View {
        VStack {
            Spacer()
        }
        .padding(18.0)
        .searchable(text: $input, placement: .toolbar, prompt: "Ask me anything...")
    }
}

#Preview {
    IntelliSpaceTab()
}
