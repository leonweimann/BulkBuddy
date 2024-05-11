//
//  Business.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 11.05.24.
//

import Foundation

// MARK: - Business

struct Business: Identifiable {
    let id: String
    var name: String
    var address: String
    var contactEmail: String
    var phoneNumber: String
    
    static let mock = Business(
        id: "BIZ10001",
        name: "Gourmet Foods",
        address: "123 Market St, Springfield, IL 62704",
        contactEmail: "info@gourmetfoods.com",
        phoneNumber: "555-1234"
    )
}
