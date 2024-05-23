//
//  User.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 14.03.24.
//

import Foundation

// MARK: - User

struct User: FirestoreData {
    static let _collectionPath: String = "users"
    
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
    
    static let mock = User(
        id: "user01",
        name: "John Doe",
        email: "john.doe@example.com",
        phoneNumber: "+49 159 4057395",
        image: "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/IJustine_2015.jpg/640px-IJustine_2015.jpg",
        birthDate: Calendar.current.date(byAdding: .year, value: -25, to: .now) ?? .now,
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
        birthDate: Calendar.current.date(byAdding: .year, value: -25, to: .now) ?? .now,
        info: "",
        balance: 0,
        permission: .none,
        basket: .init(),
        family: .init(),
        starredBusinesses: []
    )
}
