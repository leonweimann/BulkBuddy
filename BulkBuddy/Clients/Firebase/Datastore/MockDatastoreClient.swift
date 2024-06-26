//
//  MockDatastoreClient.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 14.03.24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

// MARK: - MockDatastoreClient

final class MockDatastoreClient: DatastoreClient {
    func get<T>(_ dataType: T.Type, for documentPath: String) async throws -> T where T : FirestoreData {
        throw FirestoreError.notAvailable("This feature isn't available in that environment")
    }
    
    func set(data: any FirestoreData) async throws {
        throw FirestoreError.notAvailable("This feature isn't available in that environment")
    }
}
