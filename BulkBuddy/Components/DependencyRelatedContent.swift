//
//  DependencyRelatedContent.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 21.05.24.
//

import SwiftUI

// MARK: - DependencyRelatedContent

struct DependencyRelatedContent<C, D>: View where C: View {
    init(_ dependency: D?, @ViewBuilder content: @escaping (D) -> C) {
        self.dependency = dependency
        self.content = content
    }
    
    var dependency: D?
    @ViewBuilder var content: (D) -> C
    
    var body: some View {
        if let dependency {
            content(dependency)
        } else {
            ContentUnavailableView(
                "Missing dependency `'\(String(describing: D.self))'`",
                systemImage: "questionmark.square"
            )
        }
    }
}

// MARK: - Preview

#Preview {
    DependencyRelatedContent(nil as User?) { _ in
        
    }
}
