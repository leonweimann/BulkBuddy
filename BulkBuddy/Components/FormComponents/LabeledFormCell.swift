//
//  LabeledFormCell.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 23.06.24.
//

import SwiftUI

// MARK: - LabeledFormCell

struct LabeledFormCell<C>: View where C: View {
    init(_ title: String, systemImage: String, color: Color = .accentColor, @ViewBuilder content: @escaping () -> C) {
        self.title = title
        self.systemImage = systemImage
        self.color = color
        self.content = content
    }
    
    let title: String
    let systemImage: String
    let color: Color
    @ViewBuilder var content: () -> C
    
    var body: some View {
        HStack {
            Label {
                Text(title)
            } icon: {
                Image(systemName: systemImage)
                    .foregroundStyle(color)
            }
            
            content()
                .frame(maxWidth: .infinity, alignment: .trailing)
                .tint(color)
        }
    }
}

// MARK: - Preview

#Preview {
    Form {
        LabeledFormCell(
            "Test",
            systemImage: "person",
            color: .pink
        ) {
            Toggle(isOn: .constant(true)) { }
        }
    }
}
