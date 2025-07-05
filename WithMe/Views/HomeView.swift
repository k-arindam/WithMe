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
            TabView(selection: $currentTab) {
                ForEach(HomeViewTab.allCases) { tab in
                    Tab(value: tab) {
                        Text(tab.rawValue)
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
