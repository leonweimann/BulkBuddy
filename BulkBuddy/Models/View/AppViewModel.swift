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
        Self.applicationState = applicationState
        
        self.router = router
        
        if applicationState == .mocked {
            self.currentUser = .mock
        }
    }
    
    // MARK: Config
    
    static var applicationState: ApplicationState = .mocked
    
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
    
    // MARK: Routing
    
    func showScreenHandled<C>(_ option: SegueOption = .push, onDismiss: (() -> Void)? = nil, @ViewBuilder destination: @escaping () -> C) where C: View {
        router.showScreen(option, onDismiss: onDismiss) { _ in
            HandledEnvironment(appState: Self.applicationState) {
                destination()
            }
        }
    }
    
    func inceptLoading() {
        router.showModal(id: "appProgressScreen", transition: .push(from: .top), animation: .smooth) {
            AppProgressScreen()
        }
    }
    
    func terminateLoading() {
        router.dismissModal(id: "appProgressScreen")
    }
    
    func showNotificationCapsule(_ title: String, systemImage: String, duration: Duration = .seconds(2)) {
        router.showModal(id: "notificationCapsule", transition: .offset(y: -200), animation: .snappy, alignment: .top, ignoreSafeArea: false) {
            NotificationCapsule(title: title, systemImage: systemImage)
        }
        
        Task {
            try? await Task.sleep(for: duration)
            router.dismissModal(id: "notificationCapsule")
        }
    }
    
    func showError(_ error: any Error, with title: String) {
        router.showAlert(.alert, title: title, subtitle: error.localizedDescription) { }
    }
    
    // MARK: User
    
    func updateUser(_ newUser: User?) {
        self.currentUser = newUser
        // TODO: Push / Pull data to / from database
    }
    
//    func pullUserData() async {
//        guard let authUser = authClient.authUser else { return } // force user to sign in
//        
//        do {
//            currentUser = try await datastoreClient.get(User.self, for: authUser.uid) // while get function is awaited, show loading screen (beautiful version ;D)
//        } catch {
//            showError(error, with: "Getting user data failed") // Handle error via 'router'
//        }
//    }
//    
//    func pushUserData() async {
//        guard let currentUser else { return } // handle issue via alert -> 'router' MARK: ||| or log issue, since this should never be a problem
//        
//        do {
//            try await datastoreClient.set(data: currentUser) // optionally present beautiful loading screen (if func was initiated by user itself) MARK: ||| or present progress view in a corner (like games do)
//        } catch {
//            showError(error, with: "Saving user data failed") // Handle error via 'router'
//        }
//    }
    
    func userSignOut() {
        Task {
            Task { @MainActor in
                inceptLoading()
            }
            
            do {
                try authClient.signOut()
                currentUser = nil
            } catch {
                router.showAlert(.alert, title: "Failed user sign out", subtitle: error.localizedDescription) { }
            }
            
            Task { @MainActor in
                terminateLoading()
            }
        }
    }
    
    func userDelete() {
        Task {
            Task { @MainActor in
                inceptLoading()
            }
            
            do {
                try await Task.sleep(for: .seconds(1))
            } catch {
                router.showAlert(.alert, title: "Failed user delete", subtitle: error.localizedDescription) { }
            }
            
            Task { @MainActor in
                terminateLoading()
            }
        }
    }
}
