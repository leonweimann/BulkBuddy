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
    
}

// MARK: - Injection Key

fileprivate struct AuthenticationClientInjectionKey: InjectionKey {
    static var currentValue: AuthenticationClient = MockAuthenticationClient()
}

extension InjectedValues {
    var authClient: AuthenticationClient {
        get { Self[AuthenticationClientInjectionKey.self] }
        set { Self[AuthenticationClientInjectionKey.self] = newValue }
    }
}
