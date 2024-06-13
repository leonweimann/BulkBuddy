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
    @Environment(AppViewModel.self) private var viewModel: AppViewModel?
    @Environment(\.router) private var currentRouter
    
    var appState: ApplicationState = .mocked
    @ViewBuilder var content: () -> C
    
    private var isRouterInEnvironment: Bool {
        !String(describing: currentRouter.self).lowercased().contains("mock")
    }
    
    var body: some View {
        AddRouterViewIfNeeded { router in
            HandledEnvironmentInternal(
                appState: appState,
                content: content,
                viewModel: viewModel ?? .createFrom(
                    appState: appState,
                    with: router
                )
            )
        }
        .tint(.indigo)
    }
    
    @ViewBuilder
    private func AddRouterViewIfNeeded<V>(@ViewBuilder content: @escaping (AnyRouter) -> V) -> some View where V: View {
        if isRouterInEnvironment {
            content(currentRouter)
        } else {
            RouterView { router in
                content(router)
            }
        }
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
