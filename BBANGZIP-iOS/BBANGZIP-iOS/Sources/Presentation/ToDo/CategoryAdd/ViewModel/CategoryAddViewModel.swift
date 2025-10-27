//
//  CategoryAddViewModel.swift
//  BBANGZIP
//
//  Created by 송여경 on 8/28/25.
//

import SwiftUI

@MainActor
class CategoryAddViewModel: ObservableObject {
    @Published var categoryName: String = ""
    @Published var selectedColor: CategoryColor = .Todored1
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isCompleted: Bool = false
    
    private let useCase: AddCategoryUseCaseProtocol
    
    var isCompleteButtonEnabled: Bool {
        !categoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isLoading
    }
    
    init(useCase: AddCategoryUseCaseProtocol = AddCategoryUseCase()) {
        self.useCase = useCase
    }
    
    func addCategory() {
        guard isCompleteButtonEnabled else { return }
        
        Task {
            isLoading = true
            errorMessage = nil
            defer { isLoading = false }
            
            do {
                let trimmedName = categoryName.trimmingCharacters(in: .whitespacesAndNewlines)
                _ = try await useCase.addCategory(
                    name: trimmedName,
                    color: selectedColor.apiValue
                )
                isCompleted = true
            } catch {
                errorMessage = "카테고리 추가에 실패했습니다."
            }
        }
    }
    
    func selectColor(_ color: CategoryColor) {
        selectedColor = color
    }
    
    func clearError() {
        errorMessage = nil
    }
}
