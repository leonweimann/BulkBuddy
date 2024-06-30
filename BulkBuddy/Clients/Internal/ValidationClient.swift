//
//  ValidationClient.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 12.05.24.
//

import SwiftUI

// MARK: - ValidationClient

fileprivate final actor ValidationClient {
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
            return try Regex("^\\+?\\d{1,4}[\\s.-]?\\d{3}[\\s.-]?\\d{3}[\\s.-]?\\d{4}$").wholeMatch(in: phoneNumber) != nil
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
        getValidBirthDateRange().contains(birthDate)
    }
    
    static func getValidBirthDateRange() -> ClosedRange<Date> {
        let calendar = Calendar.current
        guard
            let upperBound = calendar.date(byAdding: .year, value: -1, to: .now),
            let lowerBound = calendar.date(byAdding: .year, value: -120, to: .now)
        else {
            assertionFailure("Calculating dates failed")
            return Date.now...Date.now
        }
        return lowerBound...upperBound
    }
    
    static func checkValidity(user: User) -> Bool {
        guard
            !user.id.isEmpty,
            !user.name.isEmpty,
            !user.email.isValidEmail,
            !user.phoneNumber.isValidPhoneNumber,
            !user.birthDate.isValidAge
        else {
            return false
        }
        
        return true
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

extension User {
    var isValid: Bool {
        ValidationClient.checkValidity(user: self)
    }
}
