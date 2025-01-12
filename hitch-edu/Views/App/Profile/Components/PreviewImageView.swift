//
//  PreviewImageView.swift
//  hitch-edu
//
//  Created by Godson Umoren on 1/12/25.
//

import SwiftUI

struct PreviewImageView: View {
    @Binding var selectedImage: UIImage? // The image selected by the user
    @Binding var isUploading: Bool // Tracks upload state
    @Binding var uploadError: String? // Error message for failed uploads
    @Binding var uploadSuccess: Bool // Tracks success state
    @Environment(\.dismiss) var dismiss // Allows dismissing the view
    
    var onUpload: (UIImage) -> Void // Callback for handling the upload action
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let image = selectedImage {
                    // Display the selected image
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 300, maxHeight: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(radius: 8)
                } else {
                    // No image selected
                    Text("No image selected")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
                
                Spacer()
                
                // Buttons for Cancel and Upload
                HStack(spacing: 20) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Cancel")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                    
                    if let image = selectedImage {
                        Button(action: {
                            isUploading = true
                            uploadError = nil
                            uploadSuccess = false
                            
                            // Call the upload action
                            onUpload(image)
                        }) {
                            Text(isUploading ? "Uploading..." : "Upload")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                        .disabled(isUploading) // Disable button while uploading
                    }
                }
                .padding(.horizontal)
                
                // Feedback messages
                if let uploadError = uploadError {
                    Text(uploadError)
                        .foregroundColor(.red)
                        .font(.footnote)
                }
                if uploadSuccess {
                    Text("Image uploaded successfully!")
                        .foregroundColor(.green)
                        .font(.footnote)
                }
            }
            .padding()
            .navigationTitle("Preview Image")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
