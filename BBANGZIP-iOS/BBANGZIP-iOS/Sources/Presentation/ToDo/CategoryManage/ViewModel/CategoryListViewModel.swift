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
    @Published var todoData: TodoData?
    @Published var activeCategories: [Category] = []
    @Published var stoppedCategories: [Category] = []
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
            todoData = try await repository.fetchTimerTodos()
            makeSections()
        } catch {
        }
    }
    
    func updateCategory(_ updated: Category) {
        if let index = categories.firstIndex(where: { $0.id == updated.id }) { categories[index] = updated
            makeSections()
        }
    }
    
    func removeCategory(id: Int) {
        categories.removeAll(where: { $0.id == id })
        makeSections()
    }
    
    // TODO: mock 업데이트용이므로 서버 API 연결 시 삭제
    func persistCategory(_ category: Category) async {
        do {
            try await repository.updateCategory(category)
        } catch {
            print("카테고리 업데이트 저장 실패: \(error)")
        }
    }
    
    // TODO: mock 삭제용이므로 서버 API 연결 시 삭제
    func persistDeleteCategory(id: Int) async {
        do {
            try await repository.deleteCategory(id: id)
        } catch {
            print("카테고리 삭제 저장 실패: \(error)")
        }
    }
    
    private func makeSections() {
        activeCategories = categories.filter{ !$0.isStopped }
        stoppedCategories = categories.filter{ $0.isStopped }
    }
}

