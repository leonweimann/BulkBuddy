//
//  ValidatableSection.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 23.05.24.
//

import SwiftUI

// MARK: - ValidatableSection

struct ValidatableSection<C>: View where C: View {
    init(_ title: String, @ViewBuilder content: @escaping (ValidationStageContainer) -> C) {
        self.title = title
        self.content = content
    }
    
    var title: String
    @ViewBuilder var content: (ValidationStageContainer) -> C
    
    private var container = ValidationStageContainer()
    
    var body: some View {
        Section {
            content(container)
                .environment(container)
        } header: {
            Text(title)
        } footer: {
            if let text = container.footerText {
                Text(text)
            }
        }
    }
}

@Observable
final class ValidationStageContainer {
    var cellStages = [ValidationCellStage.ID : ValidationCellStage]()
    
    func stage(for cellID: ValidationCellStage.ID) -> ValidationCellStage? {
        cellStages
            .first { key, _ in
                key == cellID
            }?
            .value
    }
    
    var footerText: String? {
        guard
            let stage = cellStages.first(where: { $0.value.invalid })?.value,
            let issue = stage.issue()
        else {
            return nil
        }
        
        return issue
    }
}

struct ValidationCellStage: Identifiable {
    var id = UUID().uuidString
    var issue: () -> String?
    
    var invalid: Bool { issue() != nil }
}

// MARK: - Preview

#Preview {
    HandledEnvironment {
        Form {
            let user = User.mock
            
            ValidatableSection("Test") { container in
                ValidatableCell(
                    "envelope",
                    color: .blue,
                    validationContent: user.email
                ) { mail in
                    return .init {
                        return nil
                    }
                } content: {
                    
                }
            }
        }
    }
}

struct ValidatableCell<C, V>: View where C: View, V: Equatable {
    init(
        _ icon: String,
        color: Color,
        validationContent: V,
        validationState: @escaping (V) -> ValidationCellStage,
        @ViewBuilder content: @escaping () -> C
    ) {
        self.icon = icon
        self.color = color
        self.validationContent = validationContent
        self.validationState = validationState
        self.content = content
    }
    
    init(
        _ icon: String,
        color: Color,
        validationContent: V,
        issues: @escaping (V) -> String?,
        @ViewBuilder content: @escaping () -> C
    ) {
        self.icon = icon
        self.color = color
        self.validationContent = validationContent
        self.validationState = { vc in
            ValidationCellStage { issues(vc) }
        }
        self.content = content
    }
    
    @Environment(ValidationStageContainer.self) private var container
    private let id = UUID().uuidString
    
    var icon: String
    var color: Color
    var validationContent: V
    var validationState: (V) -> ValidationCellStage
    
    @ViewBuilder var content: () -> C
    
    private var showIssue: Bool {
        validationState(validationContent).invalid
    }
    
    var body: some View {
        IconContentCell(
            icon: showIssue ? "exclamationmark.triangle.fill" : icon,
            color: showIssue ? .red : color
        ) {
            content()
        }
        .onChange(of: validationContent) { oldValue, newValue in
            container.cellStages[id] = validationState(newValue)
        }
    }
}
