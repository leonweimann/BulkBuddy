//
//  AuthenticationClient.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 14.03.24.
//

import FirebaseAuth
import Foundation

// MARK: - AuthenticationClient

final class AuthenticationClient {
    private let auth = Auth.auth()
    var authUser: FirebaseAuth.User? { auth.currentUser }
    
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthDataResult {
        try await auth.createUser(withEmail: email, password: password)
    }
    
    @discardableResult
    func signIn(email: String, password: String) async throws -> AuthDataResult {
        try await auth.signIn(withEmail: email, password: password)
    }
    
    func signOut() throws {
        try auth.signOut()
    }
    
    func delete() async throws {
        try await authUser?.delete()
    }
}

// MARK: - Injection Key

fileprivate struct AuthenticationClientInjectionKey: InjectionKey {
    static var currentValue = AuthenticationClient()
}

extension InjectedValues {
    var authClient: AuthenticationClient {
        get { Self[AuthenticationClientInjectionKey.self] }
        set { Self[AuthenticationClientInjectionKey.self] = newValue }
    }
}
