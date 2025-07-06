//
//  CollectionTab.swift
//  WithMe
//
//  Created by Arindam Karmakar on 05/07/25.
//

import SwiftUI

struct CollectionTab: View {
    @EnvironmentObject private var dataController: WMDataController
    
    @State private var selectedEntity: WMEntity? = nil
    
    let spacing: CGFloat = 8.0
    let clipShape: RoundedRectangle = RoundedRectangle(cornerRadius: 12.0)
    let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 8), count: 2)
    
    @ViewBuilder
    private func buildEntityCard(for entity: WMEntity) -> some View {
        let imageURL = entity.fullURL!
        let thumbnailURL = entity.fullThumbnailURL!
        
        ZStack(alignment: .bottomTrailing) {
            Image(uiImage: UIImage(contentsOfFile: thumbnailURL.path())!)
                .resizable()
                .aspectRatio(1, contentMode: .fill)
            
            VisualBlurEffect(blurStyle: .systemThickMaterialDark)
                .mask(
                    RadialGradient(
                        gradient: Gradient(colors: [.black.opacity(0.6), .clear]),
                        center: .bottomTrailing,
                        startRadius: 0,
                        endRadius: 150
                    )
                )
            
            HStack {
                Button {
                    selectedEntity = entity
                } label: {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                }
                
                ShareLink(item: imageURL) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
            .buttonStyle(.glass)
            .padding(8.0)
        }
        .clipShape(clipShape)
    }
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns, spacing: spacing) {
                ForEach(dataController.userData) { data in
                    buildEntityCard(for: data)
                }
            }
        }
        .scrollIndicators(.never)
        .padding(spacing)
        .ignoresSafeArea(.all, edges: [.bottom])
        .sheet(item: $selectedEntity) { entity in
            if let url = entity.fullURL,
               let uiImage = UIImage(contentsOfFile: url.path()) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .clipShape(clipShape)
                    .glassEffect(in: clipShape)
            }
        }
    }
}

#Preview {
    CollectionTab()
}
