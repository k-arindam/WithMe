//
//  WMDatabaseService.swift
//  WithMe
//
//  Created by Arindam Karmakar on 05/07/25.
//

import Foundation
import FirebaseFirestore

internal final class WMDatabaseService {
    internal init(with userID: UUID) {
        self.userID = userID
    }
    
    private let userID: UUID
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private let databaseQueue = DispatchQueue(label: "in.karindam.WithMe.WMDatabaseServiceQueue", qos: .background)
    
    func fetchUserData<T>() -> [T] where T: Portable {
        if let data = try? Data(contentsOf: userDataURL),
           let value = try? decoder.decode([T].self, from: data) {
            return value
        }
        
        return []
    }
    
    func updateUserData<T>(with value: [T]) -> Void where T: Portable {
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
