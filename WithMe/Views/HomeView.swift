//
//  HomeView.swift
//  WithMe
//
//  Created by Arindam Karmakar on 04/07/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var dataController: WMDataController
    
    @State private var currentTab: HomeViewTab = .intelliSpace
    
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
                    Tab(value: tab, role: tab.role) {
                        switch tab {
                        case .intelliSpace:
                            IntelliSpaceTab()
                        case .collection:
                            CollectionTab()
                        case .settings:
                            SettingsTab()
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
        case settings = "Settings"
        
        var icon: String {
            switch self {
            case .intelliSpace:
                return "apple.intelligence"
            case .collection:
                return "list.and.film"
            case .settings:
                return "gear"
            }
        }
        
        var role: TabRole? {
            switch self {
            case .intelliSpace:
                return .search
            default:
                return nil
            }
        }
    }
}

#Preview {
    HomeView()
}
