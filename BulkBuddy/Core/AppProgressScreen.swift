//
//  AppProgressScreen.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 20.05.24.
//

import SwiftUI

// MARK: - AppProgressScreen

struct AppProgressScreen: View {
    // MARK: Config
    var animationSpeed = 0.2
    var contentImages = ["qrcode.viewfinder", "barcode.viewfinder", "creditcard.viewfinder"]
    static private let loaderTitle = Array("BulkBuddy")
    
    // MARK: Animation
    @State private var animate = false
    @State private var loadingIndication = Array(repeating: false, count: loaderTitle.count)
    @State private var animationPeriod = 0
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.background)
            
            VStack(alignment: .center, spacing: 32) {
                ZStack {
                    appIconBase
                    
                    appIconImage
                        .padding(24)
                }
                .frame(width: 200, height: 200)
                
                ZStack {
                    additionalLoadingIndicator
                        .animation(.bouncy, value: showAdditionalLoadingIndicator)
                        .animation(.default, value: additionalLoadingIndicatorContent)
                    
                    appNameText
                        .onChange(of: animate) { if $1 { animateCharRecursively() } }
                        .animation(.bouncy, value: loadingIndication)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .onAppear { animate = true }
        .onDisappear { animate = false }
    }
    
    private var appIconBase: some View {
        RoundedRectangle(cornerRadius: 32, style: .continuous)
            .fill(.accent.gradient)
            .aspectRatio(1, contentMode: .fit)
    }
    
    private var appIconImage: some View {
        Image(systemName: "cart")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(.white)
            .background {
                Rectangle()
                    .opacity(0)
                    .frame(width: 100, height: 40)
                    .overlay(appIconCartContent)
                    .offset(x: 14, y: -20)
            }
    }
    
    private var appIconCartContent: some View {
        Image(systemName: contentImages[currentAppIconCartContentIndex])
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(.white)
            .fontWeight(.semibold)
            .padding(4)
            .clipped()
            .contentTransition(.symbolEffect)
    }
    
    private var appNameText: some View {
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(0 ..< Self.loaderTitle.count, id: \.self) { index in
                let isCurrent = loadingIndication[index]
                
                Text(String(Self.loaderTitle[index]))
                    .foregroundStyle(isCurrent ? .secondary : .primary)
                    .offset(y: isCurrent ? -4 : 0)
            }
        }
        .font(.largeTitle)
        .fontWeight(.bold)
    }
    
    private var additionalLoadingIndicator: some View {
        additionalLoadingIndicatorText("...")
            .opacity(0)
            .overlay(alignment: .leading) {
                additionalLoadingIndicatorText(additionalLoadingIndicatorContent)
                    .foregroundStyle(.secondary)
                    .contentTransition(.numericText())
            }
            .offset(y: showAdditionalLoadingIndicator ? 32 : 0)
            .opacity(showAdditionalLoadingIndicator ? 1 : 0)
    }
    
    private func additionalLoadingIndicatorText(_ string: String) -> some View {
        Text(string)
            .font(.title)
            .fontWeight(.bold)
    }
    
    // MARK: Dynamic Config
    private var currentBouncedChar: Int? { loadingIndication.firstIndex(of: true) }
    
    private var showAdditionalLoadingIndicator: Bool { animationPeriod > 2 }
    
    private var currentAppIconCartContentIndex: Int { animationPeriod % contentImages.count }
    
    // MARK: Animation Logic
    private var additionalLoadingIndicatorContent: String {
        guard let currentBouncedChar else { return "." }
        let dotCount = Int(currentBouncedChar / 3)
        return String(repeating: ".", count: dotCount + 1)
    }
    
    private func animateCharRecursively(current index: Int = 0) {
        guard animate else { return }
        
        guard index < Self.loaderTitle.count else {
            DispatchQueue.main.asyncAfter(deadline: .now() + animationSpeed) {
                animateCharRecursively()
            }
            
            animationPeriod += 1
            return
        }
        
        loadingIndication[index] = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationSpeed) {
            animateCharRecursively(current: index + 1)
            loadingIndication[index] = false
        }
    }
}

// MARK: - Preview

#Preview {
    HandledEnvironment {
        AppProgressScreen()
    }
}
 
