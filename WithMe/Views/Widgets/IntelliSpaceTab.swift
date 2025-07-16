//
//  IntelliSpaceTab.swift
//  WithMe
//
//  Created by Arindam Karmakar on 15/07/25.
//

import SwiftUI

struct IntelliSpaceTab: View {
    let textfieldShape = Capsule()
    
    @State private var input = String()
    @EnvironmentObject private var dataController: WMDataController
    
    @MainActor private func handleSubmit() -> Void {
        dataController.submit(input: input)
        input = ""
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 24.0) {
            ScrollViewReader { proxy in
                ScrollView(.vertical) {
                    LazyVStack {
                        ForEach(dataController.messages) { message in
                            HStack {
                                if message.sender == .user { Spacer() }
                                
                                Group {
                                    switch message.content {
                                    case .text(let data):
                                        Text(data)
                                            .foregroundStyle(.white)
                                    case .image(let data):
                                        Image(uiImage: UIImage(data: data)!)
                                    }
                                }
                                .padding(12.0)
                                .background(message.sender.associatedColor)
                                .clipShape(.rect(cornerRadius: 18.0))
                                .frame(minWidth: 0.0, maxWidth: 242.0, alignment: message.sender == .user ? .trailing : .leading)
                                
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
        .animation(.easeInOut, value: dataController.messages)
    }
}

#Preview {
    IntelliSpaceTab()
}
