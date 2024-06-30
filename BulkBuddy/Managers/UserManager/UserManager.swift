//
//  UserManager.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 30.06.24.
//

import Foundation

// MARK: - UserManager

protocol UserManager {
    var isSigned: Bool { get }
    var signedUserID: String? { get }
    
    func createUser(_ user: User, with password: String) async throws
    func signIn(email: String, password: String) async throws -> User
    func signOut() throws
    func deleteUser(_ user: User) async throws
    func userModel() async throws -> User
    func saveUserModel(_ user: User) async throws
}

extension UserManager {
    func wrappedError(_ error: any Error) -> UserError {
        switch error {
        case is FirestoreError: return UserError.internalIssue(error as! FirestoreError)
        default: return error as! UserError // This may cause app to crash. Would be the signal to check, which case isn't handled
        }
    }
}

// MARK: - Injection Key

fileprivate struct UserManagerInjectionKey: InjectionKey {
    static var currentValue: any UserManager = MockUserManager()
}

extension InjectedValues {
    var userManager: any UserManager {
        get { Self[UserManagerInjectionKey.self] }
        set { Self[UserManagerInjectionKey.self] = newValue }
    }
}
