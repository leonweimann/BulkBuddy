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
    var birthDate: Date
    var info: String
    var balance: Double
    var permission: UserPermissionLevel
    var basket: UserBasket
    var family: UserFamily
    
    static func == (lhs: User, rhs: User) -> Bool { lhs.id == rhs.id }
    
    static let mock: User = User(
        id: "user01",
        name: "John Doe",
        email: "john.doe@example.com",
        phoneNumber: "123-456-7890",
        birthDate: Date(),
        info: "Loyal customer",
        balance: 150.50,
        permission: .owner,
        basket: UserBasket(),
        family: UserFamily()
    )
}
