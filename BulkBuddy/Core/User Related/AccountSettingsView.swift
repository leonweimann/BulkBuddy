//
//  AccountSettingsView.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 12.05.24.
//

import SwiftfulRouting
import SwiftfulUI
import SwiftUI

// MARK: - AccountSettingsView

struct AccountSettingsView: View {
    @Environment(\.router) private var router
    
    var user: User = User.mock
    
    var body: some View {
        Form {
            deleteUserSection
        }
        .navigationTitle(user.name)
    }
    
    private var deleteUserSection: some View {
        Section {
            Button(role: .destructive, action: requestDeleteAccount) {
                Label(
                    "Erase \(user.name) from BulkBuddy",
                    systemImage: "trash"
                )
                .foregroundStyle(.red)
            }
        } header: {
            Text("Permanently Delete Your Account")
        } footer: {
            Text("This action is irreversible. All data will be permanently removed. For assistance, contact support.")
        }
    }
    
    private func requestDeleteAccount() {
        router.showAlert(
            .confirmationDialog,
            title: "Permanently Delete Your Account",
            subtitle: "Please note that deleting your account is irreversible. Once deleted, all your data will be permanently removed, and you will not be able to retrieve any stored information or access the services with this account again. If you are certain you wish to proceed, click on the confirm button below. If you need further assistance or have any questions, please contact our support team."
        ) {
            Button(role: .destructive, action: {}) {
                Text("Confirm")
            }
        }
    }
}

// MARK: - Preview

#Preview {
    HandledEnvironment {
        AccountSettingsView()
    }
}
