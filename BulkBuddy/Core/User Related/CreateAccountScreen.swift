//
//  CreateAccountScreen.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 12.05.24.
//

import SwiftfulRouting
import SwiftfulUI
import SwiftUI

// MARK: - CreateAccountScreen

struct CreateAccountScreen: View {
    @Environment(\.router) private var router
    
    @Binding var model: AccountModel
    var onSignUpButtonPressed: ((AccountModel) async -> Void)? = nil
    
    @State private var currentFocus: CreateAccountScreenFocus?
    @State private var showPassword = false
    
    private var isFormValid: Bool {
        model.email.isValidEmail && model.password.isValidPassword && model.password == model.passwordRepetition && model.name.count > 2 && model.birthDate.isValidAge
    }
    
    var body: some View {
        Form {
            Section("eMail") {
                Text(model.email)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
            }
            
            passwordSection
            
            personalInformationSection
            
            Section {
                Button(action: onSignUpButtonPressedInternal) {
                    Label("Sign up", systemImage: "arrow.right.circle")
                }
                .tint(.primary)
                .disabled(!isFormValid)
            }
        }
        .autocorrectionDisabled()
        .navigationTitle("Create your Account")
    }
    
    private var passwordSection: some View {
        Section("Password") {
            ConvenienceTextField(
                titleKey: "Password",
                text: $model.password,
                isSecureField: !showPassword,
                isFocused: getFocusBinding(for: .password),
                validContentSymbol: "checkmark.circle",
                isContentValid: isPasswordContentValidHandler,
                onSubmit: toggleCurrentFocus
            )
            .textContentType(.newPassword)
            
            ConvenienceTextField(
                titleKey: "Repeat your Password",
                text: $model.passwordRepetition,
                isSecureField: !showPassword,
                isFocused: getFocusBinding(for: .passwordRepetition),
                validContentSymbol: "checkmark.circle",
                isContentValid: isPasswordContentValidHandler,
                onSubmit: toggleCurrentFocus
            )
            .textContentType(.newPassword)
            
            Toggle(isOn: $showPassword) {
                Label("Show Password", systemImage: "ellipsis.rectangle")
            }
        }
        .textInputAutocapitalization(.never)
    }
    
    private var personalInformationSection: some View {
        Section("Personal Information") {
            ConvenienceTextField(
                titleKey: "Name",
                text: $model.name,
                isFocused: getFocusBinding(for: .name),
                onSubmit: toggleCurrentFocus
            )
            .textContentType(.name)
            .textInputAutocapitalization(.words)
            
            DatePicker(selection: $model.birthDate, displayedComponents: .date) {
                Label("Birth Date", systemImage: "calendar")
            }
            .onChange(of: model.birthDate, onBirthDateChange)
        }
    }
    
    private func getFocusBinding(for focus: CreateAccountScreenFocus) -> Binding<Bool>? {
        Binding {
            currentFocus == focus
        } set: { newValue in
            if newValue { currentFocus = focus }
            else { currentFocus = nil }
        }
    }
    
    private func isPasswordContentValidHandler(password: String) -> Bool {
        password.isValidPassword
    }
    
    private func onBirthDateChange(oldValue: Date, newValue: Date) {
        if !newValue.isValidAge {
            router.showAlert(.alert, title: "Invalid birth date", subtitle: "Your birth date doesn't fulfill the validation requirements. If this is your real birth date, please contact the support.") { }
            model.birthDate = .now
        }
    }
    
    private var loadingOverlayModal: some View {
        Rectangle()
            .fill(.black)
            .opacity(0.6)
            .overlay {
                ProgressView()
            }
            .ignoresSafeArea()
    }
    
    private func onSignUpButtonPressedInternal() {
        Task {
            Task { @MainActor in
                router.showModal(id: "LoadingOverlayModal") { loadingOverlayModal }
            }
            
            await onSignUpButtonPressed?(model)
            
            Task { @MainActor in
                router.dismissModal(id: "LoadingOverlayModal")
                router.dismissScreen()
            }
        }
    }
    
    private func toggleCurrentFocus() {
        switch currentFocus {
        case .password:
            currentFocus = .passwordRepetition
        case .passwordRepetition:
            currentFocus = .name
        default:
            currentFocus = nil
        }
    }
}

extension CreateAccountScreen {
    private enum CreateAccountScreenFocus: Hashable {
        case password, passwordRepetition, name
    }
}

// MARK: - Preview

fileprivate struct PreviewHelper: View {
    @State private var model = AccountModel(email: "leonweimann@icloud.com")
    
    var body: some View {
        CreateAccountScreen(model: $model) { _ in
            try? await Task.sleep(for: .seconds(1))
        }
    }
}

#Preview {
    HandledEnvironment {
        PreviewHelper()
    }
}
