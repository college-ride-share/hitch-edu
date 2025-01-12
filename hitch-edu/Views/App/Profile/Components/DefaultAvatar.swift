//
//  DefaultAvatar.swift
//  hitch-edu
//
//  Created by Godson Umoren on 1/11/25.
//

import SwiftUI
import PhotosUI

struct DefaultAvatar: View {
    var user: User
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var selectedImage: UIImage
    @State private var imageSelection: PhotosPickerItem?
    
    
    var body: some View {
        
        let name = String(user.firstname[user.firstname.startIndex]) + String(user.lastname[user.lastname.startIndex])
        
        // Photo picker button
        PhotosPicker(selection: $imageSelection,
                     matching: .images) {
            ZStack(alignment: .bottomTrailing) {
                
                ZStack {
                    Circle().frame(width: 80, height: 80)
                        .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                    Text(name)
                        .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                        .font(.geistExtraBold(size: 32))
                    
                }
                
                
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

fileprivate extension String {
    subscript(idx: Int) -> String {
        String(self[index(startIndex, offsetBy: idx)])
    }
}
