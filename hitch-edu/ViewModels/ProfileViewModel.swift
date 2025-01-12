//
//  ProfileViewModel.swift
//  hitch-edu
//
//  Created by Godson Umoren on 1/12/25.
//

import Foundation
import SwiftUI
import Combine

class ProfileViewModel: ObservableObject {
    @Published var user: User? = SessionManager.shared.currentUser
    @Published var selectedImage: UIImage? // The image selected by the user
    @Published var isUploading = false // Upload progress state
    @Published var uploadError: String? // Error message if the upload fails
    @Published var uploadSuccess = false // Indicates if the upload succeeded
    
    private var cancellables = Set<AnyCancellable>()
    private let userService = UserService()
    
    private let baseURL = Constants.API.baseURL + "/user"
    
    /// Uploads the selected profile picture for the current user
    func uploadProfilePhoto() -> Future<Bool, Never> {
        Future { promise in
            guard let user = self.user else {
                self.uploadError = "User not logged in."
                promise(.success(false))
                return
            }
            guard let image = self.selectedImage else {
                self.uploadError = "No image selected."
                promise(.success(false))
                return
            }

            // Convert UIImage to JPEG Data
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                self.uploadError = "Failed to process image."
                promise(.success(false))
                return
            }

            self.isUploading = true
            self.uploadError = nil
            self.uploadSuccess = false

            self.userService.uploadProfilePhoto(userId: user.id, imageData: imageData)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    self.isUploading = false
                    switch completion {
                    case .failure(let error):
                        self.uploadError = "Upload failed: \(error.localizedDescription)"
                        promise(.success(false))
                    case .finished:
                        break
                    }
                }, receiveValue: { [weak self] response in
                    guard let self = self else { return }
                    self.uploadSuccess = true
                    self.uploadError = nil
                    SessionManager.shared.currentUser = self.user
                    promise(.success(true))
                })
                .store(in: &self.cancellables)
        }
    }


}
