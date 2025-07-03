//
//  HomeView.swift
//  WithMe
//
//  Created by Arindam Karmakar on 04/07/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var dataController: WMDataController
    
    let shortcutService = WMShortcutService()
    
    var body: some View {
        VStack {
            Image(uiImage: dataController.image)
                .resizable()
                .scaledToFit()
            
            Button("Add Share Screenshot Shortcut") {
                Task { @MainActor in
                    await shortcutService.add(shortcut: .shareScreenShot)
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    HomeView()
}
