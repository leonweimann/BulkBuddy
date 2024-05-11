//
//  HandledEnvironment.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 15.03.24.
//

import SwiftUI
import SwiftfulRouting

// MARK: - HandledEnvironment

struct HandledEnvironment<C>: View where C: View {
    var appState: ApplicationState = .mocked
    @ViewBuilder var content: () -> C
    
    var body: some View {
        RouterView { router in
            HandledEnvironmentInternal(
                appState: appState,
                content: content,
                viewModel: .createFrom(
                    appState: appState,
                    with: router
                )
            )
        }
        .tint(.indigo)
    }
    
    private struct HandledEnvironmentInternal: View {
        let appState: ApplicationState
        @ViewBuilder var content: () -> C
        @State var viewModel: AppViewModel
        
        var body: some View {
            content()
                .environment(viewModel)
                .environment(\.applicationState, viewModel.applicationState)
        }
    }
}

// MARK: - Preview

#Preview {
    HandledEnvironment {
        
    }
}
