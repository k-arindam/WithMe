//
//  WMLLMInput.swift
//  WithMe
//
//  Created by nuuuron on 15/07/25.
//

import Foundation

struct WMLLMInput: Portable {
    init(instructions: String, prompt: String) {
        self.id = UUID()
        self.instructions = instructions
        self.prompt = prompt
    }
    
    let id: UUID
    let instructions: String
    let prompt: String
}
