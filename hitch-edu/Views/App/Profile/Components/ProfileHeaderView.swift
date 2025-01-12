//
//  ProfileHeaderView.swift
//  hitch-edu
//
//  Created by Godson Umoren on 1/11/25.
//

import SwiftUI

struct ProfileHeaderView: View {
    @State private var selectedImage: UIImage?
    @State private var showPreview = false
    @StateObject private var viewModel = ProfileViewModel()
    
    private var defaultImage: UIImage {
        UIImage(systemName: "person.crop.circle.fill") ?? UIImage()
    }
    
    private var nonOptionalBinding: Binding<UIImage> {
        Binding(
            get: { selectedImage ?? defaultImage },
            set: { selectedImage = $0 }
        )
    }
    
    var body: some View {
        HStack {
            if let user = viewModel.user {
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(user.firstname) \(user.lastname)")
                        .font(.geistMonoSemiBold(size: 36))
                        .fontWeight(.bold)
                    
                    // Profile Rating
                    HStack(spacing: 8) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.secondary)
                        
                        Text("5.00")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .background(Color.secondary.opacity(0.4))
                    .cornerRadius(8)
                }
                
                Spacer()
                
                if selectedImage != nil {
                    ProfilePhoto(selectedImage: nonOptionalBinding)
                } else {
                    DefaultAvatar(user: user, selectedImage: nonOptionalBinding)
                }
            } else {
                Text("User not found")
                    .foregroundColor(.red)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .sheet(isPresented: $showPreview) {
            // Present the preview image view
            PreviewImageView(
                selectedImage: $selectedImage,
                isUploading: $viewModel.isUploading,
                uploadError: $viewModel.uploadError,
                uploadSuccess: $viewModel.uploadSuccess
            ) { image in
                viewModel.selectedImage = image
                viewModel.uploadProfilePhoto()

            }
        }
        .onChange(of: selectedImage) { _, newValue in
            if newValue != nil {
                showPreview = true
            }
        }
    }
}


//struct ProfileHeaderView: View {
//    @State private var selectedImage: UIImage?
//    @State private var isUploading = false
//    @State private var uploadError: String?
//    
//    private var user: User? {
//        return SessionManager.shared.currentUser
//    }
//    
//    private var defaultImage: UIImage {
//        UIImage(systemName: "person.crop.circle.fill") ?? UIImage()
//    }
//    
//    private var nonOptionalBinding: Binding<UIImage> {
//        Binding(
//            get: { selectedImage ?? defaultImage },
//            set: { selectedImage = $0 }
//        )
//    }
//    
//    var body: some View {
//        HStack {
//            if let user = user {
//                VStack(alignment: .leading, spacing: 8) {
//                    
//                    Text("\(user.firstname) \(user.lastname)")
//                        .font(.geistMonoSemiBold(size: 36))
//                        .fontWeight(.bold)
//                    // MARK: - Profile Rating
//                    HStack(spacing: 8) { // Increased spacing from 4 to 8
//                        Image(systemName: "heart.fill")
//                            .foregroundColor(.secondary)
//                        
//                        Text("5.00")
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
//                    }
//                    .padding(.horizontal, 8) // Wider horizontal padding
//                    .padding(.vertical, 6)   // Keep vertical padding the same
//                    .background(Color.secondary.opacity(0.4))
//                    .cornerRadius(8)
//                }
//                
//                Spacer()
//                
//                if selectedImage != nil {
//                    ProfilePhoto(selectedImage: nonOptionalBinding)
//                } else {
//                    DefaultAvatar(user: user, selectedImage: nonOptionalBinding)
//                }
//            } else {
//                Text("User not found")
//                    .foregroundColor(.red)
//            }
//        }
//        .frame(maxWidth: .infinity)
//        .padding()
//    }
//    
//   
//}

#Preview {
    ProfileHeaderView()
}
