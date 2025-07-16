//
//  WMMessage.swift
//  WithMe
//
//  Created by Arindam Karmakar on 16/07/25.
//

import SwiftUI

internal struct WMMessage: Portable {
    let id: UUID
    let content: Content
    let sender: Sender
    
    enum Content: PortableWithoutID {
        case text(data: String)
        case image(data: Data)
    }
    
    enum Sender: Codable, Hashable, Sendable {
        case user
        case assistant
        
        var associatedColor: Color {
            switch self {
            case .user:
                    .blue
            case .assistant:
                    .gray
            }
        }
    }
}
