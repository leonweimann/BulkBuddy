//
//  ProductManager.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 30.06.24.
//

import Foundation

// MARK: - ProductManager

final actor ProductManager {
    
}

// MARK: - Injection Key

fileprivate struct ProductManagerInjectionKey: InjectionKey {
    static var currentValue = ProductManager()
}

extension InjectedValues {
    var productManager: ProductManager {
        get { Self[ProductManagerInjectionKey.self] }
        set { Self[ProductManagerInjectionKey.self] = newValue }
    }
}
