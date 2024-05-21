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
    @Environment(AppViewModel.self) private var viewModel
    
    // MARK: Properties
    
    var user: User = User.mock
    
    // MARK: Visual
    
    var body: some View {
        Form {
            deleteUserSection
        }
        .navigationTitle(user.name)
        .toolbar { toolbar }
    }
    
    private var toolbar: some ToolbarContent {
        ToolbarItem {
            Menu {
                Button(action: copyUserID) {
                    Label("Copy user id", systemImage: "doc.on.doc")
                }
            } label: {
                Label("More", systemImage: "ellipsis.circle")
            }
        }
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
    
    // MARK: Logic
    
    private func copyUserID() {
        // TODO: Implementation
    }
    
    private func requestDeleteAccount() {
        viewModel.router.showAlert(
            .confirmationDialog,
            title: "Permanently Delete Your Account",
            subtitle: "Please note that deleting your account is irreversible. Once deleted, all your data will be permanently removed, and you will not be able to retrieve any stored information or access the services with this account again. If you are certain you wish to proceed, click on the confirm button below. If you need further assistance or have any questions, please contact our support team."
        ) {
            Button(role: .destructive, action: handleDeleteAccount) {
                Text("Confirm")
            }
        }
    }
    
    private func handleDeleteAccount() {
        // TODO: Implementation
    }
}

// MARK: - Preview

#Preview {
    HandledEnvironment {
        AccountSettingsView()
    }
}
