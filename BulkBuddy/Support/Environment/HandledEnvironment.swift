//
//  HandledEnvironment.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 15.03.24.
//

import SwiftUI

// MARK: - HandledEnvironment

struct HandledEnvironment<C>: View where C: View {
    init(state: ApplicationState = .mocked, @ViewBuilder content: @escaping () -> C) {
        self.viewModel = state.viewModel()
        self.content = content
    }
    
    @ViewBuilder var content: () -> C
    @State private var viewModel: AppViewModel
    
    var body: some View {
        content()
            .environment(viewModel)
            .environment(\.applicationState, viewModel.applicationState)
    }
}

// MARK: - Preview

#Preview {
    HandledEnvironment {
        
    }
}
