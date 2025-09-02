//
//  CategoryListViewModel.swift
//  BBANGZIP
//
//  Created by 김송희 on 9/2/25.
//

import SwiftUI

@MainActor
final class CategoryListViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let repository: TodoRepository
    private let addCategoryUseCase: AddCategoryUseCaseProtocol
    
    init(repository: TodoRepository,
         addCategoryUseCase: AddCategoryUseCaseProtocol = AddCategoryUseCase()
    ) {
        self.repository = repository
        self.addCategoryUseCase = addCategoryUseCase
    }
    
    func fetchCategories() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            categories = try await repository.fetchTimerTodos()
        } catch {
            print("카테고리 불러오기 실패: \(error)")
        }
    }
    
    func updateCategory(_ updated: Category) {
        if let index = categories.firstIndex(where: { $0.id == updated.id }) { categories[index] = updated
        }
    }
}

