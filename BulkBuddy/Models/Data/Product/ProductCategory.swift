//
//  ProductCategory.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 11.05.24.
//

import Foundation

// MARK: - ProductCategory

struct ProductCategory: Identifiable, Codable {
    let id: String
    var title: String
    var priceUnit: PriceUnit
}
