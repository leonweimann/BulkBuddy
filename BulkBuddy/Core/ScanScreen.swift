//
//  ScanScreen.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 11.05.24.
//

import CodeScanner
import SwiftfulUI
import SwiftUI

// MARK: - ScanScreen

struct ScanScreen: View {
    @Environment(AppViewModel.self) private var viewModel
    
    @State private var scanValue: String?
    @State private var isTorchOn = false
    
    private var hasScanned: Bool { scanValue != nil }
    private var torchSymbol: String { "flashlight.\(isTorchOn ? "on" : "off").fill" }
    
    var body: some View {
        CodeScannerView(
            codeTypes: [.qr],
            showViewfinder: !hasScanned,
            simulatedData: UUID().uuidString,
            shouldVibrateOnSuccess: true,
            isTorchOn: isTorchOn,
            isPaused: hasScanned,
            videoCaptureDevice: .zoomedCameraForQRCode(),
            completion: handleCodeScannerCompletion
        )
        .ignoresSafeArea()
        .overlay(alignment: .top) {
            if !hasScanned {
                viewExplanationBubble
            }
        }
        .overlay(alignment: .trailing) {
            scannerControls
        }
        .onChange(of: scanValue, handleScanValueChange)
        .animation(.default, value: scanValue)
    }
    
    // MARK: Visual
    
    private var viewExplanationBubble: some View {
        Text("Scan a product's QR code")
            .foregroundStyle(.white)
            .font(.callout)
            .fontWeight(.semibold)
            .padding()
            .frame(maxWidth: .infinity)
            .background(.accent.tertiary, in: .capsule)
            .padding()
            .transition(.offset(y: -150))
    }
    
    private var scannerControls: some View {
        VStack(spacing: 8) {
            Toggle(isOn: $isTorchOn) {
                Image(systemName: torchSymbol)
            }
            .toggleStyle(.circleIcon())
            .animation(.default, value: isTorchOn)
            .offset(y: -2)
            
            if hasScanned {
                Image(systemName: "arrow.up.backward")
                    .font(.title3)
                    .padding()
                    .transition(.opacity)
                    .asButton(.opacity, action: presentProductSheet)
                    .padding(.vertical)
            }
            
            CircleIconToggleAsButton(isOn: hasScanned, color: .red, action: onCancelPressed) {
                Image(systemName: "xmark")
                    .fontWeight(.bold)
                    .padding(-2)
            }
        }
        .frame(width: 64)
        .padding(.vertical, 8)
        .background(.regularMaterial, in: .rect(cornerRadius: 16))
        .padding()
    }
    
    private func CircleIconToggleAsButton<L>(isOn: Bool, color: Color, action: @escaping () -> Void, @ViewBuilder label: () -> L) -> some View where L: View {
        Toggle(isOn: .constant(isOn)) {
            label()
                .foregroundStyle(isOn ? .primary : .secondary)
        }
        .toggleStyle(.circleIcon(color: color))
        .disabled(true)
        .asButton(.press, action: action)
        .disabled(!isOn)
        .animation(.default, value: isOn)
    }
    
    // MARK: Logic
    
    private func presentProductSheet() {
        viewModel.showScreenHandled(.sheet) {
            ContentUnavailableView(
                "This screen will be produced in future",
                systemImage: "tray.and.arrow.down"
            )
        }
    }
    
    private func onTorchButtonPressed() {
        isTorchOn.toggle()
    }
    
    private func onCancelPressed() {
        scanValue = nil
    }
    
    private func handleScanValueChange(oldValue: String?, newValue: String?) {
        if newValue == nil { isTorchOn = false }
        else { /*presentProductSheet()*/ } // Should product sheet be presented instantly? -> configurable in app settings
    }
    
    private func handleCodeScannerCompletion(with result: Result<ScanResult, ScanError>) {
        switch result {
        case .success(let scan):
            scanValue = scan.string
            
        case .failure(let error):
            viewModel.showError(error, with: "Scanning QR-Code failed")
        }
    }
}

// MARK: - Preview

#Preview {
    HandledEnvironment {
        ScanScreen()
    }
}
