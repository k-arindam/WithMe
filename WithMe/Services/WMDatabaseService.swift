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
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    let fileManager = FileManager.default
//    let userdataCollection = Firestore.firestore().collection("user-data")
    let databaseQueue = DispatchQueue(label: "in.karindam.WithMe.databaseQueue", qos: .background)
    
    func fetchUserData<T>() -> [T] where T: CodeSendable {
        if let data = try? Data(contentsOf: userDataURL),
           let value = try? decoder.decode([T].self, from: data) {
            return value
        }
        
        return []
    }
    
    func updateUserData<T>(with value: [T]) -> Void where T: CodeSendable {
        self.databaseQueue.async {
            guard let jsonData = try? self.encoder.encode(value) else { return }
            try? jsonData.write(to: self.userDataURL)
        }
    }
    
    private var userDataURL: URL {
        let fileName = userID.uuidString + ".json"
        return WMUtils.generateURL(for: fileName, at: .json)
    }
}
