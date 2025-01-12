//
//  PreviewImageView.swift
//  hitch-edu
//
//  Created by Godson Umoren on 1/12/25.
//

import SwiftUI
import TOCropViewController
import Combine

struct PreviewImageView: View {
    @Binding var selectedImage: UIImage?
    @Binding var isUploading: Bool
    @Binding var uploadError: String?
    @Binding var uploadSuccess: Bool
    @Binding var showPreview: Bool
    var onUpload: (UIImage) -> Future<Bool, Never>
    @State private var isCropping = true

    var body: some View {
        ZStack {
            ImageCropperView(
                image: $selectedImage,
                isCropping: $isCropping,
                showPreview: $showPreview,
                onCropComplete: { croppedImage in
                    self.selectedImage = croppedImage
                    self.isUploading = true
                    self.onUpload(croppedImage)
                        .sink { success in
                            self.isUploading = false
                            if success {
                                self.showPreview = false
                            }
                        }
                        .store(in: &cancellables)
                }
            )
            .disabled(isUploading)
            .interactiveDismissDisabled(isUploading)

            if isUploading {
                // Overlay spinner and disable interaction
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    ProgressView("Uploading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .foregroundColor(.white)
                        .padding()
                }
            }
        }
        .alert(isPresented: Binding<Bool>(
            get: { uploadError != nil },
            set: { if !$0 { uploadError = nil } }
        )) {
            Alert(
                title: Text("Upload Error"),
                message: Text(uploadError ?? "An unknown error occurred."),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    @State private var cancellables = Set<AnyCancellable>()
}
