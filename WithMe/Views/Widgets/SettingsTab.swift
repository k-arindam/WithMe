//
//  SettingsTab.swift
//  WithMe
//
//  Created by Arindam Karmakar on 15/07/25.
//

import SwiftUI

struct SettingsTab: View {
    @State private var updateNameAlertVisible: Bool = false
    @State private var privacyAlertVisible: Bool = false
    @State private var edgeAI: Bool = true
    
    let shortcutService = WMShortcutService()
    let footerColor: Color = .white.opacity(0.5)
    let footerPadding: CGFloat = 24.0
    
    private func buildButton(label: Label<Text, Image>, completion: @escaping VoidCallback) -> some View {
        Button(action: completion) { label }
            .tint(.white)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                Section("USER") {
                    buildButton(label: Label("Arindam Karmakar", systemImage: "person")) {
                        updateNameAlertVisible = true
                    }
                }
                
                Section("UTILS") {
                    buildButton(label: Label("Add shortcut", systemImage: "plus.app")) {
                        Task {
                            await shortcutService.add(shortcut: .shareScreenShot)
                        }
                    }
                    
                    buildButton(label: Label("Run shortcut", systemImage: "bolt")) {
                        Task {
                            await shortcutService.run(shortcut: .shareScreenShot)
                        }
                    }
                }
                
                Section("PRIVACY") {
                    Toggle(isOn: $edgeAI) {
                        Label("Process data on-device", systemImage: "iphone.smartbatterycase.gen2")
                    }
                    .disabled(true)
                    .onTapGesture {
                        privacyAlertVisible = true
                    }
                    
                    buildButton(label: Label("Privacy Policy", systemImage: "info")) {
                        //
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 0.0) {
                Text("WithMe AI v0.0.1")
                Text("https://withme.karindam.in")
            }
            .font(.system(size: 13.0))
            .tint(footerColor)
            .foregroundStyle(footerColor)
            .padding(.leading, footerPadding)
            .padding(.bottom, footerPadding)
        }
        .alert("AI Privacy", isPresented: $privacyAlertVisible) {
            Button("Got it!", role: .cancel, action: {})
        } message: {
            Text("All brains, no cloud (yet)! This app currently runs its AI magic entirely on your device. Fast, private, and delightfully offline.\n\nServer-powered superpowers are cooking and will be served hot soon.\n\nAnd don’t worry, your personal data stays yours. We don’t peek, poke, or store a thing outside this device!")
        }
        .alert("Update Name", isPresented: $updateNameAlertVisible) {
            Button("Save", action: { updateNameAlertVisible = false })
        } message: {
            Text("")
        }


    }
}

#Preview {
    SettingsTab()
}
