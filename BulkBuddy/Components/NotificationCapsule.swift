//
//  NotificationCapsule.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 23.05.24.
//

import SwiftUI

// MARK: - NotificationCapsule

struct NotificationCapsule: View {
    var title: String = "This is a notification"
    var systemImage: String = "questionmark.square"
    
    var body: some View {
        Label(title, systemImage: systemImage)
            .font(.footnote)
            .fontWeight(.medium)
            .lineLimit(1)
            .frame(height: 48)
            .padding(.horizontal, 32)
            .background {
                Capsule()
                    .fill(.background)
                    .shadow(color: .primary.opacity(0.4), radius: 4)
            }
            .padding()
    }
}

// MARK: - Preview

#Preview {
    NotificationCapsule()
}
