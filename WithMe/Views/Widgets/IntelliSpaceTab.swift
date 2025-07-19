//
//  IntelliSpaceTab.swift
//  WithMe
//
//  Created by Arindam Karmakar on 15/07/25.
//

import SwiftUI

struct IntelliSpaceTab: View {
    let textfieldShape: any Shape = Capsule()
    let maxChatWidth: CGFloat = 300.0
    
    @State private var input = String()
    @EnvironmentObject private var dataController: WMDataController
    @EnvironmentObject private var imageSheetController: WMImageSheetController
    
    @MainActor private func handleSubmit() -> Void {
        dataController.submit(input: input)
        input = ""
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 24.0) {
            if dataController.messages.isEmpty {
                Spacer()
                Image(.handWave)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 58.0, height: 58.0)
                    .opacity(0.5)
                Spacer()
            } else {
                ScrollViewReader { proxy in
                    ScrollView(.vertical) {
                        VStack {
                            ForEach(dataController.messages) { message in
                                HStack {
                                    if message.sender == .user { Spacer() }
                                    
                                    Group {
                                        switch message.content {
                                        case .text(let data):
                                            Text(data)
                                                .foregroundStyle(.white)
                                                .padding(12.0)
                                        case .image(let data):
                                            let uiImage = UIImage(data: data)!
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: maxChatWidth, height: 200.0)
                                                .onTapGesture {
                                                    imageSheetController.present(with: uiImage)
                                                }
                                        }
                                    }
                                    .background(message.sender.associatedColor)
                                    .clipShape(.rect(cornerRadius: 18.0))
                                    .frame(minWidth: 0.0, maxWidth: maxChatWidth, alignment: message.sender == .user ? .trailing : .leading)
                                    
                                    if message.sender == .assistant { Spacer() }
                                }
                            }
                        }
                    }
                    .scrollIndicators(.never)
                    .defaultScrollAnchor(.bottom)
                    .onChange(of: dataController.messages) { _, newValue in
                        proxy.scrollTo(newValue.last, anchor: .bottom)
                    }
                }
            }
            
            let disabled = dataController.busy
            HStack(alignment: .center) {
                TextField("Ask me anything...", text: $input)
                    .textFieldStyle(.plain)
                    .onSubmit(handleSubmit)
                    .padding(12.0)
                    .background(
                        Capsule()
                            .fill(.gray.opacity(0.3))
                    )
                
                Button(action: handleSubmit) {
                    Group {
                        if disabled {
                            ProgressView()
                        } else {
                            Image(systemName: "arrow.up")
                        }
                    }
                    
                    .frame(maxWidth: 50.0, maxHeight: .infinity, alignment: .center)
                }
                .glassButtonStyleWithFallback(prominent: true)
            }
            .frame(maxHeight: 48.0)
            .disabled(disabled)
        }
        .padding(24.0)
    }
}

#Preview {
    IntelliSpaceTab()
}
