//
//  FirebaseDatastoreClient.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 14.03.24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

// MARK: - FirebaseDatastoreClient

final class FirebaseDatastoreClient: DatastoreClient {
    private let database = Firestore.firestore()
    
    func get<T>(_ dataType: T.Type, for documentPath: String) async throws -> T where T: FirestoreData {
        try await database
            .collection(dataType._collectionPath)
            .document(documentPath)
            .getDocument()
            .data(as: dataType)
    }
    
    func set(data: any FirestoreData) async throws {
        try await database
            .collection(data.collectionPath)
            .document(data.documentPath)
            .setData(data.firestoreDocumentData())
    }
}
