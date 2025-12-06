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
    @Published var activeCategories: [Category] = []
    @Published var stoppedCategories: [Category] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let fetchCategoriesUseCase: FetchCategoriesUseCase
    private let addCategoryUseCase: AddCategoryUseCaseProtocol
    private let updateOrderUseCase: UpdateCategoryOrderUseCaseProtocol
    private var hasOrderChanged: Bool = false
    
    init(
        fetchCategoriesUseCase: FetchCategoriesUseCase,
        addCategoryUseCase: AddCategoryUseCaseProtocol = AddCategoryUseCase(),
        updateOrderUseCase: UpdateCategoryOrderUseCaseProtocol = UpdateCategoryOrderUseCase()
    ) {
        self.fetchCategoriesUseCase = fetchCategoriesUseCase
        self.addCategoryUseCase = addCategoryUseCase
        self.updateOrderUseCase = updateOrderUseCase
    }
    
    func fetchCategories() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            categories = try await fetchCategoriesUseCase.execute()
            makeSections()
            hasOrderChanged = false
        } catch {
            errorMessage = "카테고리를 불러오지 못했습니다."
            LoggerFactory.create(category: .data)
                .error("FetchCategories Error: \(error.localizedDescription)")
        }
    }
    
    func updateCategory(_ updated: Category) {
        if let index = categories.firstIndex(where: { $0.id == updated.id }) {
            categories[index] = updated
            makeSections()
        }
    }
    
    func removeCategory(id: Int) {
        categories.removeAll(where: { $0.id == id })
        makeSections()
        hasOrderChanged = true
    }
    
    func moveActiveCategories(fromOffsets: IndexSet, toOffset: Int) {
        var newActive = activeCategories
        newActive.move(fromOffsets: fromOffsets, toOffset: toOffset)
        
        let stopped = stoppedCategories
        categories = newActive + stopped
        
        makeSections()
        
        hasOrderChanged = true
    }
    
    func persistCategoryOrderIfNeeded() async {
        guard hasOrderChanged else { return }
        hasOrderChanged = false
        
        let ids = categories.map { $0.id }
        
        do {
            try await updateOrderUseCase.execute(categoryIds: ids)
        } catch {
            LoggerFactory.create(category: .data)
                .error("UpdateCategoryOrder Persist Error: \(error.localizedDescription)")
        }
    }
    
    func reorderActiveCategory(
        from fromIndex: Int,
        to toIndex: Int
    ) {
        guard fromIndex != toIndex,
              fromIndex >= 0, fromIndex < activeCategories.count,
              toIndex >= 0, toIndex < activeCategories.count else { return }
        
        var newActive = activeCategories
        let moved = newActive.remove(at: fromIndex)
        newActive.insert(moved, at: toIndex)
        
        let stopped = stoppedCategories
        categories = newActive + stopped
        
        makeSections()
        hasOrderChanged = true
    }
    
    func persistCategory(_ category: Category) async {
        // TODO: TodoView에서 사용 안 하면 지워주세요!!
        print("persistCategory mock 호출: \(category)")
    }
    
    func persistDeleteCategory(id: Int) async {
        print("persistDeleteCategory mock 호출: \(id)")
    }
    
    private func makeSections() {
        activeCategories = categories.filter { !$0.isStopped }
        stoppedCategories = categories.filter { $0.isStopped }
    }
}
