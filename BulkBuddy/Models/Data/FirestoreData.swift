//
//  FirestoreData.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 16.05.24.
//

import Foundation

protocol FirestoreData: Identifiable, Equatable, Codable {
    static var _collectionPath: String { get }
}

extension FirestoreData {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    func firestoreDocumentData() throws -> [String : Any] {
        let data = try JSONEncoder().encode(self)
        
        guard
            let documentData = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String : Any]
        else {
            throw FirestoreError.encoding("Failed encoding \(String(describing: Self.self)) to Firestore documentData")
        }
        
        return documentData
    }
    
    var collectionPath: String { Self._collectionPath }
    var documentPath: String { String(describing: id) }
}
