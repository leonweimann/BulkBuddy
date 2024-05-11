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
            
        }
        .navigationTitle("BulkBuddy")
        .toolbar {
            Label("Profile", systemImage: "person.circle")
                .font(.title2)
                .padding(8)
                .background(.black.opacity(0.001))
                .offset(x: 8)
                .asButton(.opacity, action: showProfileScreen)
        }
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
