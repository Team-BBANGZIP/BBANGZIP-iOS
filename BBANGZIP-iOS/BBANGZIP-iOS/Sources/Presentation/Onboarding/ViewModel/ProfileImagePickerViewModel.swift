//
//  ProfileImagePickerViewModel.swift
//  BBANGZIP
//
//  Created by 송여경 on 10/26/25.
//

import SwiftUI

@MainActor
final class ProfileImagePickerViewModel: ObservableObject {
    @Published var selectedImage: String?
    @Published var tempSelectedImage: String?
    
    let profileImages = [
        "Profile_1",
        "Profile_2",
        "Profile_3",
        "Profile_4",
        "Profile_5",
        "Profile_6"
    ]
    
    private let onSave: (String) -> Void
    
    init(
        currentImage: String?,
        onSave: @escaping (String) -> Void
    ) {
        self.selectedImage = currentImage
        self.tempSelectedImage = currentImage
        self.onSave = onSave
    }
    
    func selectImage(_ imageName: String) {
        tempSelectedImage = imageName
    }
    
    func confirmSelection() {
        if let temp = tempSelectedImage {
            selectedImage = temp
            onSave(temp)
        }
    }
    
    func cancelSelection() {
        tempSelectedImage = selectedImage
    }
}




