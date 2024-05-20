//
//  FirebaseAuthenticationClient.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 14.03.24.
//

import FirebaseAuth
import Foundation

// MARK: - FirebaseAuthenticationClient

final class FirebaseAuthenticationClient: AuthenticationClient {
    private let auth = Auth.auth()
    var authUser: FirebaseAuth.User? { auth.currentUser }
    
    func createUser(email: String, password: String) async throws {
        try await auth.createUser(withEmail: email, password: password)
    }
    
    func signIn(email: String, password: String) async throws {
        try await auth.signIn(withEmail: email, password: password)
    }
    
    func signOut() throws {
        try auth.signOut()
    }
}
