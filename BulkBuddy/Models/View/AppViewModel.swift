//
//  AppViewModel.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 14.03.24.
//

import Observation
import SwiftfulRouting
import SwiftUI

// MARK: - AppViewModel

@Observable
final class AppViewModel {
    private init(state applicationState: ApplicationState, router: AnyRouter) {
        InjectedValues.configure(for: applicationState)
        self.applicationState = applicationState
        self.router = router
    }
    
    let applicationState: ApplicationState
    
    var router: AnyRouter
        
    static func createFrom(appState: ApplicationState, with router: AnyRouter) -> AppViewModel { AppViewModel(state: appState, router: router) }
}
