//
//  DatastoreClient.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 14.03.24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

// MARK: - DatastoreClient

protocol DatastoreClient {
    
}

// MARK: - InjectionKey

fileprivate struct DatastoreClientInjectionKey: InjectionKey {
    static var currentValue: any DatastoreClient = MockDatastoreClient()
}

extension InjectedValues {
    var datastoreClient: DatastoreClient {
        get { Self[DatastoreClientInjectionKey.self]  }
        set { Self[DatastoreClientInjectionKey.self] = newValue }
    }
}