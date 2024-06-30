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
