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
    func snapshot<T>(_ dataType: T.Type, for documentPath: String) async throws -> DocumentSnapshot where T: FirestoreData {
        try await Task.sleep(for: .seconds(.random(in: 0..<2))) // For providing asynchrony
        
        switch dataType {
        default:
            throw FirestoreError.notAvailable("This feature isn't available in that environment")
        }
    }
    
    func get<T>(_ dataType: T.Type, for documentPath: String) async throws -> T where T : FirestoreData {
        try await Task.sleep(for: .seconds(.random(in: 0..<2))) // For providing asynchrony
        
        switch dataType {
        case is User.Type:
            return User.mock as! T
        default:
            throw FirestoreError.notAvailable("This feature isn't available in that environment")
        }
    }
    
    func set(data: any FirestoreData) async throws {
        throw FirestoreError.notAvailable("This feature isn't available in that environment")
    }
}
