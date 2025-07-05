//
//  WMDatabaseService.swift
//  WithMe
//
//  Created by Arindam Karmakar on 05/07/25.
//

import Foundation
import FirebaseFirestore

internal final class WMDatabaseService {
    let userID: UUID = UUID(uuidString: WMDefaults.userID)!
    
    let userdataCollection = Firestore.firestore().collection("user-data")
}
