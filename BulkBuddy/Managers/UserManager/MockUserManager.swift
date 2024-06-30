//
//  MockUserManager.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 30.06.24.
//

import Foundation

// MARK: - MockUserManager

final class MockUserManager: UserManager {
    var isSigned: Bool = false
    var signedUserID: String?
    
    func createUser(_ user: User, with password: String) async throws {
        print("An user would be created now")
    }
    
    func signIn(email: String, password: String) async throws -> User {
        isSigned = true
        signedUserID = User.mock.id
        print("You would be sign in with :\(email), but due to mocked app state you are signed in with the default :\(User.mock.id)")
        return .mock
    }
    
    func signOut() throws {
        isSigned = false
        signedUserID = nil
        print("You would be signed out")
    }
    
    func deleteUser(_ user: User) async throws {
        print("User would be deleted")
        try signOut()
    }
    
    func userModel() async throws -> User {
        .mock
    }
}
