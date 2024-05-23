//
//  WelcomeView.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 12.05.24.
//

import AuthenticationServices
import SwiftUI

// MARK: - WelcomeView

struct WelcomeView: View {
    @Environment(\.colorScheme) private var scheme
    @Environment(\.router) private var router
    
    @State private var model = AccountModel()
    
    var body: some View {
        Form {
            Section {
                AnimatedWelcomeCell()
            }
            .listRowBackground(Color.clear)
            
            ConvenienceTextField(
                titleKey: "eMail",
                text: $model.email,
                focusDependentOverlays: false,
                isContentValid: isEmailContentValidHandler,
                onSubmit: onMailSubmission
            )
            .textContentType(.emailAddress)
            .keyboardType(.emailAddress)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            
            Section("Alternative") {
                signInWithAppleButton
                    .listRowInsets(.init())
            }
        }
        .scrollIndicators(.hidden)
        .navigationTitle("BulkBuddy")
    }
    
    private var signInWithAppleButton: some View {
        SignInWithAppleButton(.continue) { _ in
            
        } onCompletion: { _ in
            
        }
        .signInWithAppleButtonStyle(scheme == .dark ? .white : .black)
    }
    
    private func isEmailContentValidHandler(email: String) -> Bool {
        email.isValidEmail
    }
    
    private func onMailSubmission() {
        router.showScreen(.push) { _ in
            CreateAccountScreen(model: $model, onSignUpButtonPressed: handleSignUpRequest)
        }
    }
    
    private func handleSignUpRequest(model: AccountModel) async {
        try? await Task.sleep(for: .seconds(1))
    }
}

// MARK: - Preview

#Preview {
    HandledEnvironment {
        WelcomeView()
    }
}
