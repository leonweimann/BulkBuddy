//
//  User.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 14.03.24.
//

import Foundation

// MARK: - User

struct User: Identifiable, Equatable {
    let id: String
    var name: String
    var email: String
    var phoneNumber: String
    
    static func == (lhs: User, rhs: User) -> Bool { lhs.id == rhs.id }
}
