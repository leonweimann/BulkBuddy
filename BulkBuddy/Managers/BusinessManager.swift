//
//  BusinessManager.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 30.06.24.
//

import Foundation

// MARK: - BusinessManager

final actor BusinessManager {
    
}

// MARK: - Injection Key

fileprivate struct BusinessManagerInjectionKey: InjectionKey {
    static var currentValue = BusinessManager()
}

extension InjectedValues {
    var businessManager: BusinessManager {
        get { Self[BusinessManagerInjectionKey.self] }
        set { Self[BusinessManagerInjectionKey.self] = newValue }
    }
}
