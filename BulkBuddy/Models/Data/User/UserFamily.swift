//
//  UserFamily.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 11.05.24.
//

import Foundation

// MARK: - UserFamily

struct UserFamily: FirestoreData {
    static var _collectionPath: String = "user_families"
    
    var id: String = UUID().uuidString
}
