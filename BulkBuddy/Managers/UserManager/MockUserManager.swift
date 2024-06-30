//
//  MockUserManager.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 30.06.24.
//

import Foundation

// MARK: - MockUserManager

final class MockUserManager: UserManager {
    private var user: User? = User.mock
    
    var isSigned: Bool = false
    var signedUserID: String?
    
    func createUser(_ user: User, with password: String) async throws {
        print("An user would be created now")
    }
    
    func signIn(email: String, password: String) async throws -> User {
        isSigned = true
        signedUserID = User.mock.id
        user = .mock
        print("You would be sign in with :\(email), but due to mocked app state you are signed in with the default :\(User.mock.id)")
        return .mock
    }
    
    func signOut() throws {
        isSigned = false
        signedUserID = nil
        self.user = nil
        print("You would be signed out")
    }
    
    func deleteUser(_ user: User) async throws {
        try signOut()
        print("User would be deleted")
    }
    
    func userModel() async throws -> User {
        guard let user else { throw UserError.userIsNotAuthenticated }
        return user
    }
    
    func saveUserModel(_ user: User) async throws {
        self.user = user
        print("User would be updated")
    }
}
