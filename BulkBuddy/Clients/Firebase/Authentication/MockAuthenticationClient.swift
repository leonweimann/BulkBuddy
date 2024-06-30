//
//  MockAuthenticationClient.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 14.03.24.
//

import FirebaseAuth
import Foundation

// MARK: - MockAuthenticationClient

final class MockAuthenticationClient: AuthenticationClient {
    var authUser: FirebaseAuth.User? { nil }
    
    func createUser(email: String, password: String) async throws {
        print("User would be created with email '\(email)' and password '\(password)'.")
    }
    
    func signIn(email: String, password: String) async throws {
        print("User would be signed in with email '\(email)' and password '\(password)'.")
    }
    
    func signOut() throws {
        print("User would be signed out.")
    }
    
    func delete() async throws {
        print("User would be deleted.")
    }
}
