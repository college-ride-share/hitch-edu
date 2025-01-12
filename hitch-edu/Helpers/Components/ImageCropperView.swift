//
//  ImageCropperView.swift
//  hitch-edu
//
//  Created by Godson Umoren on 1/12/25.
//

import SwiftUI
import TOCropViewController

struct ImageCropperView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var isCropping: Bool
    @Binding var showPreview: Bool
    let onCropComplete: (UIImage) -> Void

    func makeUIViewController(context: Context) -> TOCropViewController {
        guard let image = image else {
            fatalError("Image must be set before presenting the crop view controller")
        }
        let cropViewController = TOCropViewController(croppingStyle: .circular, image: image)
        cropViewController.delegate = context.coordinator
        return cropViewController
    }

    func updateUIViewController(_ uiViewController: TOCropViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, TOCropViewControllerDelegate {
        var parent: ImageCropperView

        init(_ parent: ImageCropperView) {
            self.parent = parent
        }

        func cropViewController(_ cropViewController: TOCropViewController, didCropToCircularImage image: UIImage, with cropRect: CGRect, angle: Int) {
            // Keep modal open until the completion handler finishes
            DispatchQueue.global(qos: .userInitiated).async {
                self.parent.onCropComplete(image)
                DispatchQueue.main.async {
                    self.parent.isCropping = false
                    self.parent.showPreview = false
                    cropViewController.dismiss(animated: true, completion: nil)
                }
            }
        }

        func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
            parent.isCropping = false
            parent.image = nil
            parent.showPreview = false
            cropViewController.dismiss(animated: true, completion: nil)
        }
    }
}
