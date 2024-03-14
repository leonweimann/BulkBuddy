//
//  Product.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 14.03.24.
//

import Foundation

// MARK: - Product

struct Product: Identifiable, Equatable {
    let id: String
    var title: String
    
    static func == (lhs: Product, rhs: Product) -> Bool { lhs.id == rhs.id }
}
