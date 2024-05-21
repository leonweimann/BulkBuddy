//
//  Product.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 14.03.24.
//

import Foundation

// MARK: - Product

struct Product: FirestoreData {
    static let _collectionPath: String = "products"
    
    let id: String
    var title: String
    var image: String
    var expirationDate: Date
    var category: ProductCategory
    var buyCost: Double
    var saleCost: Double
    var sold: Double
    var stored: Double
    var reorderNotes: String
    var restockPending: Bool
    
    static func == (lhs: Product, rhs: Product) -> Bool { lhs.id == rhs.id }
    
    static let mock = Product(
        id: "prod001",
        title: "Organic Bananas",
        image: "bananas.jpg",
        expirationDate: Date(),
        category: ProductCategory(id: "cat02", title: "Fruits", priceUnit: .kilogram),
        buyCost: 0.80,
        saleCost: 1.20,
        sold: 35,
        stored: 65,
        reorderNotes: "Check quality on delivery",
        restockPending: true
    )
}
