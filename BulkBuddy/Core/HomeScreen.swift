//
//  HomeScreen.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 11.05.24.
//

import SwiftUI
import SwiftfulRouting
import SwiftfulUI

// MARK: - HomeScreen

struct HomeScreen: View {
    @Environment(\.router) private var router
    
    var body: some View {
        ScrollView(.vertical) {
            ContentUnavailableView(
                "Home Screen",
                systemImage: "clock.badge.exclamationmark",
                description: Text("This screen will be developed in continues coding sessions")
            )
            .padding(.vertical, 128)
        }
        .navigationTitle("BulkBuddy")
        .toolbar {
            profileButton
        }
    }
    
    private var profileButton: some View {
        Label("Profile", systemImage: "person.circle")
            .font(.title2)
            .asButton(.opacity, action: showProfileScreen)
    }
    
    private func showProfileScreen() {
        router.showScreen(.sheet) { _ in
            NavigationView {
                ProfileScreen()
            }
        }
    }
}

// MARK: - Preview

#Preview {
    HandledEnvironment {
        HomeScreen()
    }
}
