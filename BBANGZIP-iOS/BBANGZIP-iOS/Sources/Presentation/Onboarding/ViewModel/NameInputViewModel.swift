//
//  NameInputViewModel.swift
//  BBANGZIP
//
//  Created by 송여경 on 10/26/25.
//

import Foundation
import SwiftUI

@MainActor
final class NameInputViewModel: ObservableObject {
    @Published var tempUserName: String = ""
    
    let maxNameLength: Int = 20
    let currentProfileImage: String?
    private let onSave: (String) -> Void
    
    var nameCount: Int {
        tempUserName.count
    }
    
    var isNameValid: Bool {
        !tempUserName.isEmpty &&
        tempUserName.count <= maxNameLength &&
        !containsEmoji(tempUserName)
    }
    
    init(
        currentName: String,
        currentProfileImage: String?,
        onSave: @escaping (String) -> Void
    ) {
        self.tempUserName = currentName
        self.currentProfileImage = currentProfileImage
        self.onSave = onSave
    }
    
    func validateNameInput(_ newValue: String) {
        if newValue.count > maxNameLength {
            tempUserName = String(newValue.prefix(maxNameLength))
            return
        }
        
        if containsEmoji(newValue) {
            tempUserName = removeEmojis(from: newValue)
        }
    }
    
    func confirmName() {
        if isNameValid {
            onSave(tempUserName)
        }
    }
    
    private func containsEmoji(_ text: String) -> Bool {
        for scalar in text.unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F,
                 0x1F300...0x1F5FF,
                 0x1F680...0x1F6FF,
                 0x2600...0x26FF,
                 0x2700...0x27BF,
                 0x1F900...0x1F9FF,
                 0x1FA70...0x1FAFF,
                 0x1F1E6...0x1F1FF:
                return true
            default:
                continue
            }
        }
        return false
    }
    
    private func removeEmojis(from text: String) -> String {
        text.unicodeScalars.filter {
            switch $0.value {
            case 0x1F600...0x1F64F,
                 0x1F300...0x1F5FF,
                 0x1F680...0x1F6FF,
                 0x2600...0x26FF,
                 0x2700...0x27BF,
                 0x1F900...0x1F9FF,
                 0x1FA70...0x1FAFF,
                 0x1F1E6...0x1F1FF:
                return false
            default:
                return true
            }
        }
        .map(String.init)
        .joined()
    }
}
