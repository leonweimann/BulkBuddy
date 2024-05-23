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
    
    // MARK: Config
    
    let applicationState: ApplicationState
    
    @ObservationIgnored
    @Injected(\.authClient) private var authClient
    
    @ObservationIgnored
    @Injected(\.datastoreClient) private var datastoreClient
    
    // MARK: Routing
    
    var router: AnyRouter
    
    /// Route to **WelcomeView**.
    static let WelcomeRoute = AnyRoute(.fullScreenCover) { _ in
        NavigationView {
            WelcomeView()
        }
    }
    
    // MARK: Properties / Data
    
    private(set) var currentUser: User? // User should never be bound to -> always 'commit' changes to it at once via helper func and then push / pull -> helper func handles it
    
    // MARK: Methods
    
    static func createFrom(appState: ApplicationState, with router: AnyRouter) -> AppViewModel { AppViewModel(state: appState, router: router) }
    
    func inceptLoading() {
        router.showModal(id: "appProgressScreen", transition: .push(from: .top), animation: .smooth) {
            HandledEnvironment {
                AppProgressScreen()
            }
        }
    }
    
    func terminateLoading() {
        router.dismissModal(id: "appProgressScreen")
    }
    
    func showNotificationCapsule(_ title: String, systemImage: String) {
        router.showModal(transition: .push(from: .top), animation: .snappy, alignment: .top) {
            NotificationCapsule(title: title, systemImage: systemImage)
        }
    }
    
    func updateUser(_ newUser: User?) {
        self.currentUser = newUser
    }
    
    func pullUserData() async {
        guard let authUser = authClient.authUser else { return } // force user to sign in
        
        do {
            currentUser = try await datastoreClient.get(User.self, for: authUser.uid) // while get function is awaited, show loading screen (beautiful version ;D)
        } catch {
            // Handle error via 'router'
        }
    }
    
    func pushUserData() async {
        guard let currentUser else { return } // handle issue via alert -> 'router'
        
        do {
            try await datastoreClient.set(data: currentUser) // optionally present beautiful loading screen (if func was initiated by user itself)
        } catch {
            // Handle error via 'router'
        }
    }
}
