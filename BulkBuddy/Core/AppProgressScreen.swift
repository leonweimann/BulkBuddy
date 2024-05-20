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
    var contentImages = ["qrcode.viewfinder", "creditcard.viewfinder"]
    
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
                
                appNameText
            }
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
            ForEach(Array("BulkBuddy"), id: \.self) { char in
                Text(String(char))
            }
        }
        .font(.largeTitle)
        .fontWeight(.bold)
    }
}

// MARK: - Preview

#Preview {
    HandledEnvironment {
        AppProgressScreen()
    }
}
