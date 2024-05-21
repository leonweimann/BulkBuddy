//
//  ValidationClient.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 12.05.24.
//

import SwiftUI

// MARK: - ValidationClient

final actor ValidationClient {
    private init() { }
    
    static func checkValidity(eMail: String) -> Bool {
        do {
            return try Regex("[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,64}").wholeMatch(in: eMail) != nil
        } catch {
            assertionFailure("Regular Expression for eMail is invalid")
            return false
        }
    }
    
    static func checkValidity(phoneNumber: String) -> Bool {
        do {
            return try Regex(#"/^(\+\d{1,2}\s?)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$/gm"#).wholeMatch(in: phoneNumber) != nil
        } catch {
            assertionFailure("Regular Expression for phoneNumber is invalid")
            return false
        }
    }
    
    static func checkValidity(password: String) -> Bool {
        do {
            return try Regex("(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[\\W_]).{8,}").wholeMatch(in: password) != nil
        } catch {
            assertionFailure("Regular Expression for password is invalid")
            return false
        }
    }
    
    static func checkValidity(birthDate: Date) -> Bool {
        let ageComponents = Calendar.current.dateComponents([.year], from: birthDate, to: .now)
        guard let age = ageComponents.year else { return false }
        return (1..<120).contains(age)
    }
}

extension String {
    var isValidEmail: Bool {
        ValidationClient.checkValidity(eMail: self)
    }
    
    var isValidPhoneNumber: Bool {
        ValidationClient.checkValidity(phoneNumber: self)
    }
    
    var isValidPassword: Bool {
        ValidationClient.checkValidity(password: self)
    }
}

extension Date {
    var isValidAge: Bool {
        ValidationClient.checkValidity(birthDate: self)
    }
}
