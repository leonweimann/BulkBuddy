//
//  UserPermissionLevel.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 11.05.24.
//

import Foundation

// MARK: - UserPermissionLevel

enum UserPermissionLevel: Int, CaseIterable, Comparable {
    case none, mod, admin, owner
    
    
    static func < (lhs: UserPermissionLevel, rhs: UserPermissionLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
