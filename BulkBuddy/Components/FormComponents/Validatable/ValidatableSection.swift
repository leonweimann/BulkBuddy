//
//  ValidatableSection.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 23.05.24.
//

import SwiftUI

// MARK: - ValidatableSection

struct ValidatableSection<C>: View where C: View {
    init(_ title: String? = nil, @ViewBuilder content: @escaping (ValidationStageContainer) -> C) {
        self.title = title
        self.content = content
    }
    
    private let title: String?
    @ViewBuilder private var content: (ValidationStageContainer) -> C
    
    private let container = ValidationStageContainer()
    
    var body: some View {
        Section {
            content(container)
        } header: {
            if let title {
                Text(title)
            }
        } footer: {
            if let text = container.footerText {
                Text(text)
            }
        }
        .environment(container)
    }
}

// MARK: - Preview

#Preview {
    HandledEnvironment {
        Form {
            let user = User.mock
            
            ValidatableSection("Test") { _ in
                ValidatableCell("envelope", color: .blue, validationContent: user.email) { mail in
                    mail.count > 5 ? nil : "some issue"
                } content: {
                    // some ui
                }
            }
        }
    }
}
