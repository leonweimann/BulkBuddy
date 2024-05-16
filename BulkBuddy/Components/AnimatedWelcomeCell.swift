//
//  AnimatedWelcomeCell.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 12.05.24.
//

import SwiftUI
import SwiftfulUI

// MARK: - AnimatedWelcomeCell

struct AnimatedWelcomeCell: View {
    var bouncingIcons: [String] = ["qrcode.viewfinder", "cart", "chart.bar.xaxis"]
    
    @State private var frame = CGRect.zero
    @State private var showBouncingIcons = false
    
    var body: some View {
        Image(systemName: "person.3")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(.accent.gradient)
            .padding(.top, 96)
            .overlay(alignment: .top) {
                bouncingIconsView
                    .frame(height: (frame.height - 96) / 3.5)
                    .padding()
            }
            .readingFrame {
                frame = $0
            }
            .onAppear {
                withAnimation(.bouncy) {
                    showBouncingIcons = true
                }
            }
    }
    
    private var bouncingIconsView: some View {
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(bouncingIcons.indices, id: \.self) { index in
                Image(systemName: bouncingIcons[index])
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .offset(y: calculateBouncingOffset(for: index))
                    .scaleEffect(showBouncingIcons ? 1 : 0.7)
                    .opacity(showBouncingIcons ? 1 : 0.4)
            }
        }
    }
    
    private func calculateBouncingOffset(for index: Int) -> CGFloat {
        let baseOffset: CGFloat = index % 2 == 0 ? 16 : 0
        let appearOffset: CGFloat = showBouncingIcons ? 0 : 64
        let scrollComponentA: CGFloat = -(frame.minY - 160)
        let scrollComponentB: CGFloat = index % 2 == 0 ? 1.2 : 1.4
        let scrollOffset: CGFloat = frame.minY < 160 ? scrollComponentA * 0.5 * scrollComponentB : 0
        return baseOffset + appearOffset + scrollOffset
    }
}

// MARK: - Preview

#Preview {
    ScrollView(.vertical) {
        AnimatedWelcomeCell()
            .frame(width: 300)
            .padding(.top, 100)
    }
}