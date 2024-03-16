//
//  AppViewModel.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 14.03.24.
//

import SwiftUI

// MARK: - AppViewModel

@Observable
final class AppViewModel: Mockable {
    private init(state applicationState: ApplicationState) {
        InjectedValues.configure(for: applicationState)
        self.applicationState = applicationState
    }
    
    let applicationState: ApplicationState
    
    static func production() -> AppViewModel { AppViewModel(state: .production) }
    static func mocked() -> AppViewModel { AppViewModel(state: .mocked) }
}
