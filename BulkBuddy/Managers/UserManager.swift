//
//  UserManager.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 30.06.24.
//

import Foundation

// MARK: - UserManager

final actor UserManager {
    @Injected(\.authClient) private var auth
    @Injected(\.datastoreClient) private var datastore

    private func wrappedError(_ error: any Error) -> UserError {
        switch error {
        case is FirestoreError: return UserError.internalIssue(error as! FirestoreError)
        default: return error as! UserError // This may cause app to crash. Would be the signal to check, which case isn't handled
        }
    }
}

// MARK: - Injection Key

fileprivate struct UserManagerInjectionKey: InjectionKey {
    static var currentValue = UserManager()
}

extension InjectedValues {
    var userManager: UserManager {
        get { Self[UserManagerInjectionKey.self] }
        set { Self[UserManagerInjectionKey.self] = newValue }
    }
}
