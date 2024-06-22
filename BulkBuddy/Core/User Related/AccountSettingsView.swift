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
    init(user: User, saveLogicAdaption: @escaping (@escaping () -> Void) -> Void = { _ in }) {
        self.initialUser = user
        self._user = .init(initialValue: user)
        self.saveLogicAdaption = saveLogicAdaption
    }
    
    @Environment(AppViewModel.self) private var viewModel
    
    // MARK: Properties
    
    private let saveLogicAdaption: (@escaping () -> Void) -> Void
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
            .disabled(true)
            
            deleteUserSection
        }
        .navigationTitle(user.name)
        .toolbar { toolbar }
        .onFirstAppear(perform: adaptSaveLogic)
    }
    
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Button(action: copyUserID) {
                    Label("Copy user id", systemImage: "doc.on.doc")
                }
                
                Section {
                    Button(action: saveChanges) {
                        Label("Save changes", systemImage: "square.and.arrow.down")
                    }
                    
                    Button(role: .destructive, action: requestDiscardChanges) {
                        Label("Discard your changes", systemImage: "arrow.counterclockwise")
                    }
                }
                .disabled(isUserUnchanged)
                
                deleteUserSection
            } label: {
                Label("More", systemImage: "ellipsis.circle")
            }
        }
    }
    
    private var contactInformation: some View {
        ValidatableSection("Contact Information") { _ in
            ValidatableCell("envelope", color: .blue, validationContent: user.email, issue: userEmailIssue) {
                ConvenienceTextField(
                    titleKey: "eMail",
                    text: $user.email,
                    validContentSymbol: "checkmark",
                    isContentValid: isEmailContentValid
                )
            }
            .textContentType(.emailAddress)
            .keyboardType(.emailAddress)
            
            ValidatableCell("phone", color: .green, validationContent: user.phoneNumber, issue: userPhoneNumberIssue) {
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
        ValidatableSection("Personal Information") { _ in
            ValidatableCell("person", color: .indigo, validationContent: user.name, issue: userNameIssue) {
                ConvenienceTextField(
                    titleKey: "Name",
                    text: $user.name
                )
            }
            .textContentType(.name)
            
            ValidatableCell("person.text.rectangle", color: .purple, validationContent: user.info, issue: userInfoIssue) {
                ConvenienceTextField(
                    titleKey: "Something about you",
                    text: $user.info
                )
            }
        }
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
        
        ValidatableSection { _ in
            ValidatableCell("calendar", color: .red, validationContent: user.birthDate, issue: userBirthDataIssue) {
                DatePicker(
                    "Birth date",
                    selection: $user.birthDate,
                    in: ValidationClient.getValidBirthDateRange(),
                    displayedComponents: .date
                )
            }
            
            ValidatableCell("photo", color: .pink, validationContent: user.image, issue: userImageIssue) {
                NavigationLink("Profile image") {
                    WebImagePicker(image: $user.image)
                        .navigationTitle("Profile Image")
                        .toolbarTitleDisplayMode(.inline)
                }
            }
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
    
    private func userEmailIssue(_ email: String) -> String? {
        email.isValidEmail ? nil : "Your eMail isn't valid" // Provide more rich detail
    }
    
    private func userPhoneNumberIssue(_ phoneNumber: String) -> String? {
        phoneNumber.isValidPhoneNumber ? nil : "Your phone number isn't valid" // Provide more rich detail
    }
    
    private func userNameIssue(_ name: String) -> String? {
        name.count > 3 ? nil : "Your name is too short" // Provide more rich detail
    }
    
    private func userInfoIssue(_ info: String) -> String? {
        nil // Provide more rich detail
    }
    
    private func userBirthDataIssue(_ birthDate: Date) -> String? {
        nil // Provide more rich detail
    }
    
    private func userImageIssue(_ image: String) -> String? {
        nil // Provide more rich detail
    }
    
    private func adaptSaveLogic() {
        saveLogicAdaption(saveChanges)
    }
    
    private func saveChanges() {
        // TODO: Implementation
        viewModel.updateUser(user)
    }
    
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
            Button(role: .destructive, action: viewModel.userDelete) {
                Text("Confirm")
            }
        }
    }
}

// MARK: - Preview

#Preview {
    HandledEnvironment {
        AccountSettingsView(user: .mock)
    }
}
