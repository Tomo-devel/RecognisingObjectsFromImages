//
//  PhotoLibrary.swift
//  RecognisingObjectsFromImages
//
//  Created by 井上智輝 on 2023-03-15.
//

import SwiftUI
import PhotosUI

struct PhotoLibrary: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoLibrary
        
        init(_ parent: PhotoLibrary) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let plovider = results.first?.itemProvider else {
                return
            }
            
            if plovider.canLoadObject(ofClass: UIImage.self) {
                plovider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.parent.image = image as? UIImage
                }
            }
        }
    }
}
