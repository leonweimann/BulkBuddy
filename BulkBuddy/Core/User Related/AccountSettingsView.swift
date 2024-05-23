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
    
    // MARK: Visual
    
    var body: some View {
        Form {
            contactInformations
            
            personalInfomations
            
            Section("Family") {
                FormField(icon: "figure.and.child.holdinghands", style: .pink.gradient) {
                    NavigationLink("Family") {
                        
                    }
                }
            }
            
            deleteUserSection
        }
        .navigationTitle(user.name)
        .toolbar { toolbar }
            viewModel.router.showModal(transition: .push(from: .top), animation: .snappy, alignment: .top, dismissOnBackgroundTap: true, ignoreSafeArea: false) {
                VStack(spacing: 64) {
                    ZStack {
                        Capsule()
                            .fill(.background)
                            .shadow(color: .primary.opacity(0.4), radius: 4)
                        
                        Label("Copied to Clipboard", systemImage: "doc.on.clipboard")
                            .font(.footnote)
                            .fontWeight(.medium)
                    }
                    .frame(width: 200, height: 48)
                    .padding()
                    
                    Label("Copied to Clipboard", systemImage: "doc.on.clipboard")
                        .font(.footnote)
                        .fontWeight(.medium)
                        .frame(height: 48)
                        .padding(.horizontal, 32)
                        .background {
                            Capsule()
                                .fill(.background)
                                .shadow(color: .primary.opacity(0.4), radius: 4)
                        }
                }
            }
    }
    
    private var toolbar: some ToolbarContent {
        ToolbarItem {
            Menu {
                Button(action: copyUserID) {
                    Label("Copy user id", systemImage: "doc.on.doc")
                }
                
                Section {
                    Button(role: .destructive, action: requestDiscardChanges) {
                        Label("Discard your changes", systemImage: "arrow.counterclockwise")
                    }
                }
                
                deleteUserSection
            } label: {
                Label("More", systemImage: "ellipsis.circle")
            }
        }
    }
    
    private var contactInformations: some View {
        Section("Contact Information") {
            FormField(icon: "envelope", style: .blue.gradient) {
                ConvenienceTextField(
                    titleKey: "eMail",
                    text: $user.email,
                    validContentSymbol: "checkmark",
                    isContentValid: isEmailContentValid
                )
            }
            .textContentType(.emailAddress)
            .keyboardType(.emailAddress)
            
            FormField(icon: "phone", style: .green.gradient) {
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
    private var personalInfomations: some View {
        Section("Personal Information") {
            FormField(icon: "person", style: .indigo.gradient) {
                ConvenienceTextField(
                    titleKey: "Name",
                    text: $user.name
                )
            }
            .textContentType(.name)
            
            FormField(icon: "person.text.rectangle", style: .purple.gradient) {
                ConvenienceTextField(
                    titleKey: "Something about you",
                    text: $user.info
                )
            }
        }
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
        
        Section {
            FormField(icon: "calendar", style: .red.gradient) {
                DatePicker(
                    "Birth date",
                    selection: $user.birthDate,
                    in: ValidationClient.getValidBirthDateRange(),
                    displayedComponents: .date
                )
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
    
    private func FormField<S, C>(icon: String, style: S, @ViewBuilder content: @escaping () -> C) -> some View where S: ShapeStyle, C: View {
        HStack(alignment: .center, spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(style)
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
        // show quick confirmation modal
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
