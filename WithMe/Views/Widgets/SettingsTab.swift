//
//  SettingsTab.swift
//  WithMe
//
//  Created by Arindam Karmakar on 15/07/25.
//

import SwiftUI

struct SettingsTab: View {
    @State private var edgeAI: Bool = true
    
    var body: some View {
        List {
            Section("USER") {
                Text("Name")
                Text("Email ID")
            }
            
            Section("PRIVACY") {
                Toggle("Process data on edge", isOn: $edgeAI)
            }
        }
    }
}

#Preview {
    SettingsTab()
}
