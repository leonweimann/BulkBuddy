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
    
    private let title: String
    @ViewBuilder private var content: (ValidationStageContainer) -> C
    
    private let container = ValidationStageContainer()
    
    var body: some View {
        Section {
            content(container)
        } header: {
            Text(title)
        } footer: {
            if let text = container.footerText {
                Text(text)
            }
        }
        .environment(container)
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
    
    struct ValidationCellStage: Identifiable {
        var id: String
        var issue: () -> String?
        
        var invalid: Bool { issue() != nil }
        
        static func fromIssue(id: String, issue: @escaping () -> String?) -> Self {
            Self.init(id: id, issue: issue)
        }
    }
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
                    mail.count > 5 ? nil : "some issue"
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
        validationState: @escaping (V) -> ValidationStageContainer.ValidationCellStage,
        @ViewBuilder content: @escaping () -> C
    ) {
        self.id = UUID().uuidString
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
        issue: @escaping (V) -> String?,
        @ViewBuilder content: @escaping () -> C
    ) {
        self.id = UUID().uuidString
        self.icon = icon
        self.color = color
        self.validationContent = validationContent
        self.validationState = ValidatableCell<C, V>.configureValidationState(id: id, issue: issue)
        self.content = content
    }
    
    static func configureValidationState(id: String, issue: @escaping (V) -> String?) -> ((V) -> ValidationStageContainer.ValidationCellStage) {
        return { value in
            ValidationStageContainer.ValidationCellStage.fromIssue(id: id) {
                issue(value)
            }
        }
    }
    
    @Environment(ValidationStageContainer.self) private var container
    private let id: String
    
    private let icon: String
    private let color: Color
    private let validationContent: V
    private let validationState: (V) -> ValidationStageContainer.ValidationCellStage
    
    @ViewBuilder private var content: () -> C
    
    private var showIssue: Bool { validationState(validationContent).invalid }
    
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
