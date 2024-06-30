//
//  UserManager.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 30.06.24.
//

import Foundation

// MARK: - UserManager

final actor UserManager {

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
