//
//  WebImagePicker.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 23.05.24.
//

import SwiftfulRouting
import SwiftfulUI
import SwiftUI

// MARK: - WebImagePicker

struct WebImagePicker: View {
    @Environment(\.router) private var router
    
    @Binding var image: String
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Label("Browse", systemImage: "network")
                        .asButton(.opacity, action: handleBrowseRequest)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image(systemName: "xmark.circle.fill")
                        .asButton(.opacity, action: clearImage)
                        .tint(.secondary)
                }
                
                TextField("The link / url to the image", text: $image, axis: .vertical)
                    .textContentType(.URL)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .keyboardType(.URL)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Image Selection")
            } footer: {
                Text("You need to provide a link to the image you want to set. You can simply go to the web and copy on image you like.")
            }
            
            Section("Preview") {
                ImageLoader(urlString: image)
                    .frame(height: 400)
                    .listRowInsets(.init())
            }
        }
    }
    
    private func clearImage() {
        image = ""
    }
    
    private func handleBrowseRequest() {
        router.showSafari {
            URL(string: image) ?? URL(string: "https://images.google.com")!
        }
    }
}

// MARK: - Preview

fileprivate struct PreviewHelper: View {
    @State private var image: String = User.mock.image
    
    var body: some View {
        HandledEnvironment {
            WebImagePicker(image: $image)
        }
    }
}

#Preview {
    PreviewHelper()
}

