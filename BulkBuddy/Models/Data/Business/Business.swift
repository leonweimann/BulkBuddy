//
//  Business.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 11.05.24.
//

import Foundation

// MARK: - Business

struct Business: Identifiable, Equatable {
    let id: String
    var name: String
    var address: String
    var contactEmail: String
    var phoneNumber: String
    
    static func == (lhs: Business, rhs: Business) -> Bool { lhs.id == rhs.id }
    
    static let mock = Business(
        id: "BIZ10001",
        name: "Gourmet Foods",
        address: "123 Market St, Springfield, IL 62704",
        contactEmail: "info@gourmetfoods.com",
        phoneNumber: "555-1234"
    )
}
