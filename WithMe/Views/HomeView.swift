//
//  HomeView.swift
//  WithMe
//
//  Created by Arindam Karmakar on 04/07/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var dataController: WMDataController
    
    @State private var currentTab: HomeViewTab = .collection
    
    let shortcutService = WMShortcutService()
    
    var body: some View {
        VStack {
            HStack {
                Image("TxtWhiteExt")
                    .resizable()
                    .scaledToFit()
                Spacer()
            }
            .frame(height: 24.0)
            .padding(12.0)
            .padding(.top, 8.0)
            
            TabView(selection: $currentTab) {
                ForEach(HomeViewTab.allCases) { tab in
                    Tab(value: tab) {
                        switch tab {
                        case .intelliSpace:
                            VStack {
                                RoundedRectangle(cornerRadius: 12.0)
                                    .fill(.clear)
                                    .glassEffect(in: .rect(cornerRadius: 12.0))
                                    .frame(width: 300, height: 300)
                                Button("Add Shortcut") {
                                    Task {
                                        await WMShortcutService().add(shortcut: .shareScreenShot)
                                    }
                                }
                                .buttonStyle(.glass)
                            }
                        case .collection:
                            CollectionTab()
                        }
                    } label: {
                        Label(tab.rawValue, systemImage: tab.icon)
                    }
                }
            }
        }
    }
    
    enum HomeViewTab: String, Identifiable, CaseIterable {
        var id: String { rawValue }
        
        case intelliSpace = "IntelliSpace"
        case collection = "Collection"
        
        var icon: String {
            switch self {
            case .intelliSpace:
                return "apple.intelligence"
            case .collection:
                return "list.and.film"
            }
        }
    }
}

#Preview {
    HomeView()
}
