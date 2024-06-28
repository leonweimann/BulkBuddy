//
//  ImageLoader.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 11.05.24.
//

import SDWebImageSwiftUI
import SwiftUI

// MARK: - ImageLoader

struct ImageLoader: View {
    var urlString: String = "https://developer.apple.com/wwdc24/images/motion/startframe-large_2x.jpg"
    var resizingMode: ContentMode = .fill
    
    var body: some View {
        Rectangle()
            .opacity(0.001)
            .overlay {
                WebImage(url: URL(string: urlString))
                    .resizable()
                    .indicator(.activity)
                    .aspectRatio(contentMode: resizingMode)
                    .allowsHitTesting(false)
            }
            .clipped()
    }
}

// MARK: - Preview

#Preview {
    ImageLoader(resizingMode: .fit)
        .padding(64)
        .clipShape(.rect(cornerRadius: 16))
}
