//
//  BulkBuddyApp.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 14.03.24.
//

import FirebaseCore
import SwiftUI

// MARK: - BulkBuddyApp

@main
struct BulkBuddyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
        
    var body: some Scene {
        WindowGroup {
            HandledEnvironment(appState: .production) {
                ContentView()
            }
        }
    }
}

// MARK: - AppDelegate

fileprivate final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
