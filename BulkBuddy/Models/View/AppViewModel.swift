//
//  AppViewModel.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 14.03.24.
//

import SwiftUI

// MARK: - AppViewModel

@Observable
final class AppViewModel: Mockable {
    static func production() -> AppViewModel { AppViewModel() }
    static func mocked() -> AppViewModel { AppViewModel() }
}
