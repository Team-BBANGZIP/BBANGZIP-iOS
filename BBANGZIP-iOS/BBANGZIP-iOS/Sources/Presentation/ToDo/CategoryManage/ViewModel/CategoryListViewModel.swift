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
    
    init(
        fetchCategoriesUseCase: FetchCategoriesUseCase,
        addCategoryUseCase: AddCategoryUseCaseProtocol = AddCategoryUseCase()
    ) {
        self.fetchCategoriesUseCase = fetchCategoriesUseCase
        self.addCategoryUseCase = addCategoryUseCase
    }
    
    func fetchCategories() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            categories = try await fetchCategoriesUseCase.execute()
            makeSections()
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
    }
    
    func persistCategory(_ category: Category) async {
        // TODO: api 연결
        print("persistCategory mock 호출: \(category)")
    }
    
    // TODO: mock 삭제용이므로 서버 API 연결 시 삭제해야 함
    func persistDeleteCategory(id: Int) async {
        print("persistDeleteCategory mock 호출: \(id)")
    }
    
    private func makeSections() {
        activeCategories = categories.filter { !$0.isStopped }
        stoppedCategories = categories.filter { $0.isStopped }
    }
}
