//
//  CircleIconToggleStyle.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 28.06.24.
//

import SwiftfulUI
import SwiftUI

// MARK: - CircleIconToggleStyle

struct CircleIconToggleStyle: ToggleStyle {
    var color = Color.accentColor
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .contentTransition(.interpolate) // in SDK18 -> symbol magic effect ...
            .padding()
            .foregroundStyle(configuration.isOn ? .white : .primary)
            .background {
                if configuration.isOn {
                    Circle()
                        .fill(color.gradient)
                        .transition(.scale)
                } else {
                    Circle()
                        .stroke(color.tertiary, lineWidth: 2)
                        .transition(.opacity)
                }
            }
//            .padding()
            .asButton(.press) { configuration.isOn.toggle() }
    }
}

// MARK: - ToggleStyle Extension

extension ToggleStyle where Self == CircleIconToggleStyle {
    static func circleIcon(color: Color = .accentColor) -> Self {
        CircleIconToggleStyle(color: color)
    }
}

// MARK: - Preview

fileprivate struct PreviewHelper: View {
    @State private var isTorchOn = false
    
    private var torchSymbol: String {
        "flashlight.\(isTorchOn ? "on" : "off").fill"
    }
    
    var body: some View {
        Toggle(isOn: $isTorchOn) {
            Image(systemName: torchSymbol)
        }
        .toggleStyle(.circleIcon())
    }
}

#Preview {
    PreviewHelper()
}
