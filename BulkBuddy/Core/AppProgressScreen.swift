//
//  AppProgressScreen.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 20.05.24.
//

import SwiftUI

// MARK: - AppProgressScreen

struct AppProgressScreen: View {
    @State private var animate = false
    var contentImages = ["qrcode.viewfinder", /*"barcode.viewfinder",*/ "creditcard.viewfinder"]
    
    static private let loaderTitle = Array("BulkBuddy")
    @State private var loadingIndication = Array(repeating: false, count: loaderTitle.count)
    @State private var animationPeriod = 0
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.background)
                .onTapGesture { animate.toggle() }
            
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
        .onAppear { animate = true }
        .onDisappear { animate = false }
    }
    
    private var showAdditionalLoadingIndicator: Bool { animationPeriod > 2 }
    
    private var additionalLoadingIndicatorContent: String {
        guard let currentBouncedChar = loadingIndication.firstIndex(of: true) else { return "." }
        let dotCount = Int(currentBouncedChar / 3)
        return String(repeating: ".", count: dotCount + 1)
    }
    
    private func animateCharRecursively(current index: Int = 0) {
        guard animate else { return }
        
        guard index < Self.loaderTitle.count else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                animateCharRecursively()
            }
            
            animationPeriod += 1
            return
        }
        
        loadingIndication[index] = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            animateCharRecursively(current: index + 1)
            loadingIndication[index] = false
        }
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
        HStack(spacing: 0) {
            ForEach(contentImages, id: \.self) { systemName in
                cartItemCell(systemName: systemName)
            }
        }
    }
    
    private func cartItemCell(systemName: String) -> some View {
        Image(systemName: systemName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(.white)
            .fontWeight(.semibold)
            .padding(4)
    }
    
    private var appNameText: some View {
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(0 ..< Self.loaderTitle.count, id: \.self) { index in
                Text(String(Self.loaderTitle[index]))
                    .offset(y: loadingIndication[index] ? -4 : 0)
            }
        }
        .font(.largeTitle)
        .fontWeight(.bold)
    }
    
    private func additionalLoadingIndicatorText(_ string: String) -> some View {
        Text(string)
            .font(.title)
            .fontWeight(.bold)
    }
    
    private var additionalLoadingIndicator: some View {
        additionalLoadingIndicatorText("...")
            .opacity(0)
            .overlay(alignment: .leading) { additionalLoadingIndicatorAnimated }
            .offset(y: showAdditionalLoadingIndicator ? 32 : 0)
            .opacity(showAdditionalLoadingIndicator ? 1 : 0)
    }
    
    private var additionalLoadingIndicatorAnimated: some View {
        additionalLoadingIndicatorText(additionalLoadingIndicatorContent)
            .foregroundStyle(.secondary)
            .contentTransition(.numericText())
    }
}

// MARK: - Preview

#Preview {
    HandledEnvironment {
        AppProgressScreen()
    }
}
 
