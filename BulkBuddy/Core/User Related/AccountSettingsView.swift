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
    init(user: User) {
        self.initialUser = user
        self._user = .init(initialValue: user)
    }
    
    @Environment(AppViewModel.self) private var viewModel
    
    // MARK: Properties
    
    private let initialUser: User
    @State private var user: User
    
    // MARK: Computed Properties
    
    private var isUserUnchanged: Bool {
        user.email == initialUser.email &&
        user.phoneNumber == initialUser.phoneNumber &&
        user.name == initialUser.name &&
        user.info == initialUser.info &&
        user.birthDate == initialUser.birthDate &&
        user.image == initialUser.image &&
        user.family == user.family
    }
    
    // MARK: Visual
    
    var body: some View {
        Form {
            contactInformation
            
            personalInformation
            
            Section("Family") {
                IconContentCell(icon: "figure.and.child.holdinghands", color: .cyan) {
                    NavigationLink("Family") {
                        // TODO: FamilyView
                    }
                }
            }
            
            deleteUserSection
        }
        .navigationTitle(user.name)
        .toolbar { toolbar }
    }
    
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Button(action: copyUserID) {
                    Label("Copy user id", systemImage: "doc.on.doc")
                }
                
                Section {
                    Button(role: .destructive, action: requestDiscardChanges) {
                        Label("Discard your changes", systemImage: "arrow.counterclockwise")
                    }
                    .disabled(isUserUnchanged)
                }
                
                deleteUserSection
            } label: {
                Label("More", systemImage: "ellipsis.circle")
            }
        }
    }
    
    private var contactInformation: some View {
        Section("Contact Information") {
            IconContentCell(icon: "envelope", color: .blue) {
                ConvenienceTextField(
                    titleKey: "eMail",
                    text: $user.email,
                    validContentSymbol: "checkmark",
                    isContentValid: isEmailContentValid
                )
            }
            .textContentType(.emailAddress)
            .keyboardType(.emailAddress)
            
            IconContentCell(icon: "phone", color: .green) {
                ConvenienceTextField(
                    titleKey: "Phone number (\(User.mock.phoneNumber))",
                    text: $user.phoneNumber,
                    validContentSymbol: "checkmark",
                    isContentValid: isPhoneNumberContentValid
                )
            }
            .textContentType(.telephoneNumber)
            .keyboardType(.numberPad)
        }
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
    }
    
    @ViewBuilder
    private var personalInformation: some View {
        Section("Personal Information") {
            IconContentCell(icon: "person", color: .indigo) {
                ConvenienceTextField(
                    titleKey: "Name",
                    text: $user.name
                )
            }
            .textContentType(.name)
            
            IconContentCell(icon: "person.text.rectangle", color: .purple) {
                ConvenienceTextField(
                    titleKey: "Something about you",
                    text: $user.info
                )
            }
        }
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
        
        Section {
            IconContentCell(icon: "calendar", color: .red) {
                DatePicker(
                    "Birth date",
                    selection: $user.birthDate,
                    in: ValidationClient.getValidBirthDateRange(),
                    displayedComponents: .date
                )
            }
            
            IconContentCell(icon: "photo", color: .pink) {
                NavigationLink("Profile image") {
                    WebImagePicker(image: $user.image)
                        .navigationTitle("Profile Image")
                        .toolbarTitleDisplayMode(.inline)
                }
            }
        } footer: {
            optionalBirthDateFooter
        }
    }
    
    @ViewBuilder
    private var optionalBirthDateFooter: some View {
        if !user.birthDate.isValidAge {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.red)
                    .fontWeight(.bold)
                
                Text("Your birth date doesn't look right.")
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
        UIPasteboard.general.string = user.id
        viewModel.showNotificationCapsule("Copied to Clipboard", systemImage: "doc.on.clipboard")
    }
    
    private func isEmailContentValid(_ email: String) -> Bool { email.isValidEmail }
    
    private func isPhoneNumberContentValid(_ phoneNumber: String) -> Bool { phoneNumber.isValidPhoneNumber }
    
    private func requestDiscardChanges() {
        viewModel.router.showAlert(
            .alert,
            title: "Discard all your changes"
        ) {
            Button(role: .destructive, action: handleDiscardChanges) {
                Text("Continue")
            }
            
            Button(role: .cancel, action: {}) {
                Text("Cancel")
            }
        }
    }
    
    private func handleDiscardChanges() {
        user = initialUser
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
        AccountSettingsView(user: .mock)
    }
}
