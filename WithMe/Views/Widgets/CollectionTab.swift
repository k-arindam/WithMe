//
//  CollectionTab.swift
//  WithMe
//
//  Created by Arindam Karmakar on 05/07/25.
//

import SwiftUI

struct CollectionTab: View {
    @EnvironmentObject private var dataController: WMDataController
    
    let spacing: CGFloat = 8.0
    let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 2)
    
    var body: some View {
        GeometryReader { geo in
            let totalSpacing = spacing * 3
            let itemSide = (geo.size.width - totalSpacing) / 2
            
            ScrollView(.vertical) {
                LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach(dataController.userData) { data in
                        Image(uiImage: UIImage(contentsOfFile: data.fullURL!.path())!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: itemSide, height: itemSide)
                            .clipShape(RoundedRectangle(cornerRadius: 12.0))
                    }
                }
            }
            .padding(spacing)
        }
    }
}

#Preview {
    CollectionTab()
}
