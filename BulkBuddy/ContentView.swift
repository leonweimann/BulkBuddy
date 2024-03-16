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
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

// MARK: - Preview

#Preview {
    HandledEnvironment {
        ContentView()
    }
}
