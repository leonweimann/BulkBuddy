//
//  AuthenticationClient.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 14.03.24.
//

import FirebaseAuth
import Foundation

// MARK: - AuthenticationClient

protocol AuthenticationClient {
    var authUser: FirebaseAuth.User? { get }
    
    func createUser(email: String, password: String) async throws
    func signIn(email: String, password: String) async throws
    func signOut() throws
}

// MARK: - Injection Key

fileprivate struct AuthenticationClientInjectionKey: InjectionKey {
    static var currentValue: any AuthenticationClient = MockAuthenticationClient()
}

extension InjectedValues {
    var authClient: AuthenticationClient {
        get { Self[AuthenticationClientInjectionKey.self] }
        set { Self[AuthenticationClientInjectionKey.self] = newValue }
    }
}
