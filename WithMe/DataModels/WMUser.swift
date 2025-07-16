//
//  WMUser.swift
//  WithMe
//
//  Created by Arindam Karmakar on 16/07/25.
//

import Foundation

internal struct WMUser: Portable {
    let id: UUID
    let name: String
    
    func copyWith(id: UUID? = nil, name: String? = nil) -> Self {
        WMUser(
            id: id ?? self.id,
            name: name ?? self.name
        )
    }
}
