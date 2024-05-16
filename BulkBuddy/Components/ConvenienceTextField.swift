//
//  ConvenienceTextField.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 12.05.24.
//

import SwiftfulUI
import SwiftUI

// MARK: - ConvenienceTextField

struct ConvenienceTextField: View {
    init(
        titleKey: LocalizedStringKey = "",
        text: Binding<String>,
        isSecureField: Bool = false,
        autoFocussed: Bool = false,
        isFocused: Binding<Bool>? = nil,
        validContentSymbol: String = "chevron.forward.circle",
        isContentValid: ((String) -> Bool)? = nil,
        onSubmit: (() -> Void)? = nil
    ) {
        self.titleKey = titleKey
        self._text = text
        self.isSecureField = isSecureField
        self.autoFocussed = autoFocussed
        self.parentFocusOverride = isFocused
        self.validContentSymbol = validContentSymbol
        self.isContentValid = isContentValid
        self.onSubmit = onSubmit
    }
    
    let titleKey: LocalizedStringKey
    @Binding var text: String
    
    let isSecureField: Bool
    let validContentSymbol: String
    
    let autoFocussed: Bool
    @FocusState private var isFocused: Bool
    var parentFocusOverride: Binding<Bool>?
    
    let isContentValid: ((String) -> Bool)?
    let onSubmit: (() -> Void)?
    
    private var isContentValidWrapped: Bool {
        isContentValid?(text) ?? false
    }
    
    var body: some View {
        ZStack {
            textField
            
            if isContentValid != nil {
                Image(systemName: validContentSymbol)
                    .font(.headline)
                    .foregroundStyle(.accent)
                    .padding(8)
                    .asButton(.press, action: submitText)
                    .background(.black.opacity(0.001))
                    .offset(x: 8)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .offset(x: isContentValidWrapped ? 0 : 100)
            }
            
            Image(systemName: "xmark.circle")
                .font(.headline)
                .foregroundStyle(.secondary)
                .padding(8)
                .asButton(action: discardText)
                .background(.black.opacity(0.001))
                .offset(x: 8)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .offset(x: isContentValidWrapped ? 100 : 0)
                .opacity(text.isEmpty ? 0 : 1)
        }
        .onAppear(perform: handleAppear)
        .onChange(of: parentFocusOverride?.wrappedValue) { oldValue, newValue in
            if let newValue {
                isFocused = newValue
            }
        }
    }
    
    private var textField: some View {
        Group {
            if isSecureField {
                SecureField(titleKey, text: $text)
            } else {
                TextField(titleKey, text: $text)
            }
        }
        .focused($isFocused)
        .onSubmit(onFieldSubmission)
    }
    
    private func handleAppear() {
        if autoFocussed {
            isFocused = true
        }
        
        if let parentFocusOverride {
            isFocused = parentFocusOverride.wrappedValue
        }
    }
    
    private func onFieldSubmission() {
        if isContentValidWrapped {
            submitText()
        } else {
            isFocused = false
        }
    }
    
    private func submitText() {
        isFocused = false
        onSubmit?()
    }
    
    private func discardText() {
        isFocused = true
        text = ""
    }
}

// MARK: - Preview

fileprivate struct PreviewHelper: View {
    @State private var text = ""
    
    var body: some View {
        Form {
            ConvenienceTextField(text: $text)
        }
    }
}

#Preview {
    HandledEnvironment {
        PreviewHelper()
    }
}
