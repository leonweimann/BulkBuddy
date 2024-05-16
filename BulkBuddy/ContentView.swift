//
//  ContentView.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 14.03.24.
//

import SwiftUI

// MARK: - ContentView

struct ContentView: View {
    @Environment(AppViewModel.self) var viewModel
    // fs
    var body: some View {
        TabView {
            NavigationView {
                HomeScreen()
            }
            .tabItem { Label("Home", systemImage: "house") }
            
            ScanScreen()
                .tabItem { Label("Scan", systemImage: "qrcode.viewfinder") }
            
            NavigationView {
                BasketScreen()
            }
            .tabItem { Label("Basket", systemImage: "basket") }
        }
    }
}

// MARK: - Preview

#Preview {
    HandledEnvironment {
        ContentView()
    }
}
