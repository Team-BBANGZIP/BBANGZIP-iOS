//
//  CategoryManageViewModel.swift
//  BBANGZIP
//
//  Created by 김송희 on 9/2/25.
//

import SwiftUI

@MainActor
class CategoryManageViewModel: ObservableObject {
    @Published var categoryName: String = ""
    @Published var selectedColor: CategoryColor = .Todored1
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isCompleted: Bool = false
    @Published var isStopped: Bool
    
    private let useCase: UpdateCategoryUseCaseProtocol
    private let original: Category
    var categoryId: Int { original.id }
        
    var isCompleteButtonEnabled: Bool {
        !categoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isLoading
    }
    
    init(
        category: Category,
        useCase: UpdateCategoryUseCaseProtocol = UpdateCategoryUseCase()
    ) {
        self.categoryName = category.name
        self.selectedColor = category.colorType
        self.isStopped = category.isStopped
        self.useCase = useCase
        self.original = category
    }
    
    func updateCategory() -> Category {
        Category(
            id: original.id,
            name: categoryName,
            colorType: selectedColor,
            todos: original.todos,
            isStopped: isStopped
        )
    }
    
    func saveCategory() {
        guard isCompleteButtonEnabled else { return }
        
        Task {
            isLoading = true
            errorMessage = nil
            defer { isLoading = false }
            
            do {
                let trimmedName = categoryName.trimmingCharacters(in: .whitespacesAndNewlines)
                _ = try await useCase.updateCategory(
                    id: original.id,
                    name: trimmedName,
                    color: selectedColor.apiValue,
                    isStopped: isStopped
                )
                isCompleted = true
            } catch {
                errorMessage = "카테고리 저장에 실패했습니다."
            }
        }
    }
    
    func selectColor( color: CategoryColor) {
        selectedColor = color
    }
    
    func clearError() {
        errorMessage = nil
    }
}
