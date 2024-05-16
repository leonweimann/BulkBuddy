//
//  User.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 14.03.24.
//

import Foundation

// MARK: - User

struct User: Identifiable, Equatable, Codable {
    let id: String
    var name: String
    var email: String
    var phoneNumber: String
    var image: String
    var birthDate: Date
    var info: String
    var balance: Double
    var permission: UserPermissionLevel
    var basket: UserBasket
    var family: UserFamily
    var starredBusinesses: Set<Business.ID>
    
    static func == (lhs: User, rhs: User) -> Bool { lhs.id == rhs.id }
    
    static let mock = User(
        id: "user01",
        name: "John Doe",
        email: "john.doe@example.com",
        phoneNumber: "123-456-7890",
        image: "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/IJustine_2015.jpg/640px-IJustine_2015.jpg",
        birthDate: Date(),
        info: "Loyal customer",
        balance: 150.50,
        permission: .owner,
        basket: UserBasket(),
        family: UserFamily(),
        starredBusinesses: []
    )
    
    static let empty = User(
        id: UUID().uuidString,
        name: "",
        email: "",
        phoneNumber: "",
        image: "",
        birthDate: .now,
        info: "",
        balance: 0,
        permission: .none,
        basket: .init(),
        family: .init(),
        starredBusinesses: []
    )
}
