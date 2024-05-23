//
//  IconContentCell.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 23.05.24.
//

import SwiftUI

// MARK: - IconContentCell

struct IconContentCell<C>: View where C: View {
    var icon: String
    var color: Color
    @ViewBuilder var content: () -> C
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(color.gradient)
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    Image(systemName: icon)
                        .resizable()
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .aspectRatio(contentMode: .fit)
                        .padding(6)
                }
                .frame(width: 32, height: 32)
            
            content()
        }
    }
}

// MARK: - Preview

#Preview {
    Form {
        IconContentCell(icon: "key", color: .blue) {
            Text("Key")
        }
    }
}
