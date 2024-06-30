//
//  FirebaseUserManager.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 30.06.24.
//

import Foundation

// MARK: - FirebaseUserManager

final class FirebaseUserManager: UserManager {
    @Injected(\.authClient) private var auth
    @Injected(\.datastoreClient) private var datastore
    
    var isSigned: Bool { auth.authUser != nil }
    var signedUserID: String? { auth.authUser?.uid }
    
    func createUser(_ user: User, with password: String) async throws {
        precondition(
            password.isValidPassword,
            "[Bug] Somehow there was a createUser request with an inappropriate password"
        )
        
        do {
            guard
                try await !datastore.snapshot(User.self, for: user.id).exists
            else {
                throw UserError.userAlreadyExists
            }
            
            async let createAuthProfile = auth.createUser(email: user.email, password: password)
            async let createDatastoreProfile: () = datastore.set(data: user)
            
            let (_, _) = try await (createAuthProfile, createDatastoreProfile)
        } catch {
            // Since creating profiles failed -> delete data from firebase to ensure no trash data
            try? await deleteUser(user)
            throw wrappedError(error)
        }
    }
    
    func signIn(email: String, password: String) async throws -> User {
        precondition(
            email.isValidEmail && password.isValidPassword,
            "[Bug] Somehow there was a signIn request with an inappropriate email or password"
        )
        
        do {
            let result = try await auth.signIn(email: email, password: password)
            let user = try await datastore.get(User.self, for: result.user.uid)
            return user
        } catch {
            throw wrappedError(error)
        }
    }
    
    func signOut() throws {
        try auth.signOut()
    }
    
    func deleteUser(_ user: User) async throws {
        precondition(
            user.isValid,
            "[Bug] Somehow there was a deleteUser request with an inappropriate user model"
        )
        
        do {
            let deleteAuth = auth.authUser?.uid == user.id
            
            async let deleteAuthProfile: () = deleteAuth ? auth.delete() : ()
            async let deleteDatastoreProfile: () = datastore.delete(data: user)
            
            let (_, _) = try await (deleteAuthProfile, deleteDatastoreProfile)
        } catch {
            throw wrappedError(error)
        }
    }
    
    func userModel() async throws -> User {
        guard let signedUserID else { throw UserError.userIsNotAuthenticated }
        return try await datastore.get(User.self, for: signedUserID)
    }
}
