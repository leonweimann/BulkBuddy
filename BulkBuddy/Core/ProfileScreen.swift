//
//  ProfileScreen.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 11.05.24.
//

import SwiftfulRouting
import SwiftfulUI
import SwiftUI

// MARK: - ProfileScreen

struct ProfileScreen: View {
    @Environment(AppViewModel.self) private var viewModel
    
    var user: User = .mock
    @State private var saveUserLogic: (() -> Void)? = nil
    
    var body: some View {
        List {
            TeaserCell(
                urlString: user.image,
                headline: user.name,
                subheadline: user.info
            )
            .asButton(action: showAccountSettingsView)
            .listRowInsets(.init())
            
            if user.permission > .none {
                Section {
                    Button(action: switchToBusiness) {
                        Label("Switch to business", systemImage: "chart.bar.xaxis")
                    }
                    .buttonStyle(.plain)
                } footer: {
                    Text("Access the interface of your business")
                }
                .listItemTint(.monochrome)
            }
            
            Section("Your businesses") {
                ContentUnavailableView(
                    "Listed Businesses",
                    systemImage: "clock.badge.exclamationmark"
                )
            }
            
            Section("Application Settings") {
                LabeledFormCell("Color scheme", systemImage: "moon.haze.fill", color: .indigo) {
                    Toggle(isOn: .constant(true)) { }
                }
            }
        }
        .navigationTitle("Profile")
    }
    
    private func switchToBusiness() {
        viewModel.showScreenHandled(.fullScreenCover) {
            ContentUnavailableView(
                "Business View",
                systemImage: "clock.badge.exclamationmark",
                description: Text("This screen will be developed in continues coding sessions")
            )
        }
    }
    
    private func showAccountSettingsView() {
        viewModel.showScreenHandled(.push, onDismiss: saveUserLogic) {
            AccountSettingsView(user: user, saveLogicAdaption: attachSaveUserLogic)
        }
    }
    
    private func attachSaveUserLogic(saveUserLogic: @escaping () -> Void) {
        self.saveUserLogic = saveUserLogic
    }
}

// MARK: - Preview

#Preview {
    HandledEnvironment {
        ProfileScreen()
    }
}
