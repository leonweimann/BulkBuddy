//
//  AppProgressScreen.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 20.05.24.
//

import SwiftUI

// MARK: - AppProgressScreen

struct AppProgressScreen: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.background)
            
            VStack(alignment: .center, spacing: 32) {
                ZStack {
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(.accent.gradient)
                        .aspectRatio(1, contentMode: .fit)
                    
                    Image(systemName: "cart")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.white)
                        .background {
                            Rectangle()
                                .opacity(0)
                                .frame(width: 100, height: 40)
                                .overlay {
                                    Image(systemName: "qrcode.viewfinder")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundStyle(.white)
                                        .fontWeight(.semibold)
                                        .padding(4)
                                }
                                .offset(x: 14, y: -20)
                            }
                        .padding(24)
                }
                .frame(width: 200, height: 200)
                
                Text("BulkBuddy")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    HandledEnvironment {
        AppProgressScreen()
    }
}
