//
//  HomeScreen.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 11.05.24.
//

import SwiftfulRouting
import SwiftfulUI
import SwiftUI

// MARK: - HomeScreen

struct HomeScreen: View {
    @Environment(AppViewModel.self) private var viewModel
    
    var body: some View {
        ScrollView(.vertical) {
            ContentUnavailableView(
                "Home Screen",
                systemImage: "clock.badge.exclamationmark",
                description: Text("This screen will be developed in continues coding sessions")
            )
            .padding(.vertical, 128)
            
            Text("Show Welcome")
                .asButton {
                    viewModel.router.showScreen(AppViewModel.WelcomeRoute)
                }
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
        viewModel.router.showScreen(.sheet) { _ in
            DependencyRelatedContent(viewModel.currentUser) { user in
                NavigationView {
                    ProfileScreen(user: user)
                }
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
