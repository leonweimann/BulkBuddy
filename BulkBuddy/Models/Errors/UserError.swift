//
//  UserError.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 30.06.24.
//

import Foundation

// MARK: - UserError

enum UserError: Error {
    case userIsNotAuthenticated
    case userAlreadyExists
    case internalIssue(FirestoreError)
}
