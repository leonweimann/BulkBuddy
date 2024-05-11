//
//  TeaserCell.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 12.05.24.
//

import SwiftUI

// MARK: - TeaserCell

struct TeaserCell: View {
    var urlString: String = Product.mock.image
    var height: CGFloat = 200
    var headline: String = Product.mock.title
    var subheadline: String? = Product.mock.category.title
    
    var body: some View {
        ImageLoader(urlString: urlString)
            .asStretchyHeader(startingHeight: height)
            .overlay(alignment: .bottomLeading) {
                details
            }
            .overlay(alignment: .topTrailing) {
                Image(systemName: "ellipsis")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(8)
                    .background(.black.opacity(0.3))
                    .padding(8)
            }
            .overlay(alignment: .bottom) { Divider() }

    }
    
    private var details: some View {
        HStack(alignment: .bottom, spacing: 8) {
            Text(headline)
                .font(.largeTitle)
                .fontWeight(.medium)
                .foregroundStyle(.white)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)

            if let subheadline {
                Text(subheadline)
                    .font(.callout)
                    .foregroundStyle(.white.opacity(0.9))
                    .multilineTextAlignment(.trailing)
                    .lineLimit(2)
            }
        }
        .padding(.top)
        .padding(.bottom, 8)
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            LinearGradient(
                colors: [.black.opacity(0), .black.opacity(0.8)],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
}

// MARK: - Preview

#Preview {
    TeaserCell()
}
