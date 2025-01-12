//
//  ProfilePhoto.swift
//  hitch-edu
//
//  Created by Godson Umoren on 1/11/25.
//

import SwiftUI
import PhotosUI

struct ProfilePhoto: View {
    @Binding var selectedImage: UIImage
    @State private var imageSelection: PhotosPickerItem?
    
    
    var body: some View {
        
        PhotosPicker(selection: $imageSelection,
                     matching: .images) {
            ZStack(alignment: .bottomTrailing) {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(Color.textPrimary)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.background))
                    .shadow(radius: 5)
                
                
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 19.2, height: 19.2)
                    .foregroundColor(Color.appPrimary)
                    .background(Circle().fill(Color.white))
                    .overlay(Circle().stroke(Color.background, lineWidth: 4))
                    .offset(x: 2, y: -4)
            }
            
        }
                     .onChange(of: imageSelection) { _, newValue in
                         guard let newValue else { return }
                         Task {
                             if let data = try? await newValue.loadTransferable(type: Data.self),
                                let image = UIImage(data: data) {
                                 selectedImage = image
                             }
                         }
                     }
    }
}
