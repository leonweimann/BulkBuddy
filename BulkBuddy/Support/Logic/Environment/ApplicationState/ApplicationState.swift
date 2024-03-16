//
//  ApplicationState.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 15.03.24.
//

import SwiftUI

// MARK: - ApplicationState

enum ApplicationState {
    case mocked, production
    
    func viewModel() -> AppViewModel {
        switch self {
        case .mocked: return AppViewModel.mocked()
        case .production: return AppViewModel.production()
        }
    }
}

// MARK: - ApplicationStateEnvironmentKey

fileprivate struct ApplicationStateEnvironmentKey: EnvironmentKey {
    static var defaultValue: ApplicationState = .mocked
}

extension EnvironmentValues {
    var applicationState: ApplicationState {
        get { self[ApplicationStateEnvironmentKey.self] }
        set { self[ApplicationStateEnvironmentKey.self] = newValue }
    }
}
