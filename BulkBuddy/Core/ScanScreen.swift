//
//  ScanScreen.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 11.05.24.
//

import CodeScanner
import SwiftfulRouting
import SwiftfulUI
import SwiftUI

// MARK: - ScanScreen

struct ScanScreen: View {
    @Environment(AppViewModel.self) private var viewModel
    
    @State private var scanValue: String?
    @State private var isTorchOn = false
    
    private var torchSymbol: String {
        "flashlight.\(isTorchOn ? "on" : "off").fill"
    }
    
    var body: some View {
        CodeScannerView(
            codeTypes: [.qr],
            showViewfinder: true,
            simulatedData: UUID().uuidString,
            shouldVibrateOnSuccess: true,
            isTorchOn: false,
            videoCaptureDevice: .zoomedCameraForQRCode(),
            completion: handleCodeScannerCompletion
        )
        .ignoresSafeArea()
        .overlay(alignment: .top) {
            VStack {
                Text(scanValue ?? "Scan a product's qr code")
                    .font(.callout)
                    .fontWeight(scanValue == nil ? .semibold : nil)
                    .padding()
                    .lineLimit(1)
                    .contentTransition(.numericText())
                    .animation(.default, value: scanValue)
                
                Divider()
                    .background(.white)
            }
            .frame(maxWidth: .infinity)
            .background(.accent)
        }
        .overlay(alignment: .bottom) {
            VStack {
                Divider()
                
                HStack {
                    Image(systemName: torchSymbol)
                        .symbolEffect(.bounce, value: isTorchOn) // in SDK18 -> magic effect ...
                        .padding()
                        .foregroundStyle(.white)
                        .background(.accent.gradient)
                        .clipShape(.circle)
                        .asButton(.press, action: onTorchButtonPressed)
                        .padding()
                    
                    
                }
            }
            .frame(maxWidth: .infinity)
            .background(.regularMaterial)
        }
    }
    
    private func onTorchButtonPressed() {
        isTorchOn.toggle()
    }
    
    private func handleCodeScannerCompletion(with result: Result<ScanResult, ScanError>) {
        switch result {
        case .success(let scan):
            self.scanValue = scan.string
            
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
