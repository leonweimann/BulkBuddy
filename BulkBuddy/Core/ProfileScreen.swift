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
    @Environment(\.router) private var router
    
    var user: User = .mock
    
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
                AppSettingsCell("Color scheme", systemImage: "moon.haze.fill", color: .indigo) {
                    Toggle(isOn: .constant(true)) { }
                }
            }
        }
        .navigationTitle("Profile")
    }
    
    private func AppSettingsCell<C>(_ title: String, systemImage: String, color: Color = .accentColor, @ViewBuilder content: @escaping () -> C) -> some View where C: View {
        HStack(alignment: .center) {
            Label {
                Text(title)
            } icon: {
                Image(systemName: systemImage)
                    .foregroundStyle(color)
            }
            
            content()
                .frame(maxWidth: .infinity, alignment: .trailing)
                .tint(color)
        }
    }
    
    private func switchToBusiness() {
        router.showScreen(.fullScreenCover) { _ in
            ContentUnavailableView(
                "Business View",
                systemImage: "clock.badge.exclamationmark",
                description: Text("This screen will be developed in continues coding sessions")
            )
        }
    }
    
    private func showAccountSettingsView() {
        router.showScreen(.push) { _ in
            AccountSettingsView(user: user)
        }
    }
}

// MARK: - Preview

#Preview {
    HandledEnvironment {
        ProfileScreen()
    }
}
