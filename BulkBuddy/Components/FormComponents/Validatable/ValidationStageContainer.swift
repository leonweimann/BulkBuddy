//
//  ValidationStageContainer.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 23.05.24.
//

import Foundation

// MARK: - ValidationStageContainer

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
