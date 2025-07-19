//
//  SettingsTab.swift
//  WithMe
//
//  Created by Arindam Karmakar on 15/07/25.
//

import SwiftUI

struct SettingsTab: View {
    @State private var updateNameSheetVisible: Bool = false
    @State private var privacyAlertVisible: Bool = false
    @State private var newUserName: String = ""
    
    @EnvironmentObject private var authController: WMAuthController
    @EnvironmentObject private var dataController: WMDataController
    
    let shortcutService = WMShortcutService()
    let footerColor: Color = .white.opacity(0.5)
    let footerPadding: CGFloat = 24.0
    let appVersion = WMUtils.fetchAppVersion()
        
    private func buildButton(label: Label<Text, Image>, completion: @escaping VoidCallback) -> some View {
        Button(action: completion) { label }
            .tint(.white)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                Section("PROFILE") {
                    let userName = authController.user?.name ?? "Anonymous"
                    buildButton(label: Label(userName, systemImage: "person")) {
                        updateNameSheetVisible = true
                    }
                }
                
                Section("UTILS") {
                    buildButton(label: Label("Add Shortcut", systemImage: "plus.app")) {
                        Task {
                            await shortcutService.add(shortcut: .shareScreenShot)
                        }
                    }
                    
                    buildButton(label: Label("Run Shortcut", systemImage: "bolt")) {
                        Task {
                            await shortcutService.run(shortcut: .shareScreenShot)
                        }
                    }
                    
//                    buildButton(label: Label("Show Onboarding", systemImage: "lightbulb.max")) {
//                        //
//                    }
                    
                    Picker("Response Mode", systemImage: "message", selection: $dataController.responseMode) {
                        ForEach(WMResponseMode.allCases) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                }
                
                Section("PRIVACY") {
                    Toggle(isOn: $dataController.edgeAI) {
                        Label("Process data on-device", systemImage: "iphone.smartbatterycase.gen2")
                    }
                    .disabled(true)
                    .onTapGesture {
                        privacyAlertVisible = true
                    }
                    
                    buildButton(label: Label("Privacy Policy", systemImage: "info")) {
                        privacyAlertVisible = true
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 0.0) {
                Text("WithMe AI \(appVersion)")
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
        .sheet(isPresented: $updateNameSheetVisible) {
            VStack(alignment: .leading) {
                Text("Update Name")
                    .font(.title2)
                Text("No judgment here. Just a safe space for you to reinvent yourself, one letter at a time.")
                    .font(.subheadline)
                
                TextField("Your Name", text: $newUserName)
                    .textFieldStyle(.roundedBorder)
                    .padding(.vertical, 12.0)
                
                Button {
                    if !newUserName.isEmpty {
                        authController.updateUserName(to: newUserName)
                    }
                    
                    updateNameSheetVisible = false
                    newUserName = ""
                } label: {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                }
                .glassButtonStyleWithFallback(prominent: true)
            }
            .padding(.horizontal, 24.0)
            .presentationDetents([.height(250)])
        }
    }
}

#Preview {
    SettingsTab()
}
