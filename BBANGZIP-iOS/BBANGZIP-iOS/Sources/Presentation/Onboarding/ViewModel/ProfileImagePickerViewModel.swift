//
//  ProfileImagePickerViewModel.swift
//  BBANGZIP
//
//  Created by 송여경 on 10/26/25.
//

import SwiftUI

@MainActor
final class ProfileImagePickerViewModel: ObservableObject {
    @Published var selectedKey: Int?
    @Published var tempSelectedKey: Int?

    let profileImageKeys = [0,1,2,3,4,5,6]
    let selectableKeys = [1,2,3,4,5,6]

    private let onSave: (Int) -> Void
    
    init(
        currentKey: Int?,
        onSave: @escaping (Int) -> Void
    ) {
        self.selectedKey = currentKey
        self.tempSelectedKey = currentKey
        self.onSave = onSave
    }
    
    func selectImage(_ key: Int) {
        tempSelectedKey = key
    }

    func confirmSelection() {
        if let key = tempSelectedKey {
            selectedKey = key
            onSave(key)
        }
    }

    func cancelSelection() {
        tempSelectedKey = selectedKey
    }
}
