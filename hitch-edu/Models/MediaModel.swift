//
//  MediaModel.swift
//  hitch-edu
//
//  Created by Godson Umoren on 1/12/25.
//

import Foundation
import PhotosUI
import SwiftUI

struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    init?(withImage image: UIImage, forKey key: String, name:String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = name
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        self.data = data
    }
}
