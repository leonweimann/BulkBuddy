//
//  Mockable.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 14.03.24.
//

import Foundation

// MARK: - Mockable

protocol Mockable {
    static func production() -> Self
    static func mocked() -> Self
}
