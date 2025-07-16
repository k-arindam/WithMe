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
                        endRadius: 200
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
            .glassButtonStyleWithFallback()
            .padding(8.0)
        }
        .clipShape(clipShape)
        .glassEffectWithFallback(in: clipShape)
    }
    
    var body: some View {
        VStack(spacing: 32.0) {
            if dataController.userData.isEmpty {
                Group {
                    Image(.empty)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 82, height: 82)
                    Text("No screenshots in the vault yet!\nAdd and run the shortcut from anywhere — shout it to Siri or summon the mighty Action Button.\nOnce you do, your saved brilliance will show up right here.\n\nAnd hey, if the shortcut has gone rogue, just rescue it from the settings and bring it back to the party.")
                        .multilineTextAlignment(.center)
                    Button {
                        Task {
                            await WMShortcutService().run(shortcut: .shareScreenShot)
                        }
                    } label: {
                        Label("Try it now!", systemImage: "figure.run")
                    }
                    .glassButtonStyleWithFallback()
                }
                .padding(.horizontal, 15.0)
                .opacity(0.5)
            } else {
                ScrollView(.vertical) {
                    LazyVGrid(columns: columns, spacing: spacing) {
                        ForEach(dataController.userData) { data in
                            buildEntityCard(for: data)
                        }
                    }
                    
                    Color.clear
                        .frame(height: 100.0)
                }
                .scrollIndicators(.never)
            }
        }
        .padding(spacing)
        .ignoresSafeArea(.all, edges: [.bottom])
        .sheet(item: $selectedEntity) { entity in
            if let url = entity.fullURL,
               let uiImage = UIImage(contentsOfFile: url.path()) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .clipShape(clipShape)
                    .glassEffectWithFallback(in: clipShape)
                    .padding(42.0)
            }
        }
    }
}

#Preview {
    CollectionTab()
}
