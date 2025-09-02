//
//  CategoryListViewModel.swift
//  BBANGZIP
//
//  Created by 김송희 on 9/2/25.
//

import SwiftUI

import SwiftUI

@MainActor
final class CategoryListViewModel: ObservableObject {
    @Published var categories: [Category] = []
    
    private let repository: TodoRepository
    
    init(repository: TodoRepository) {
        self.repository = repository
    }
    
    func fetchCategories() async {
        do {
            let fetched = try await repository.fetchTimerTodos()
            categories = fetched
        } catch {
            print("카테고리 불러오기 실패: \(error)")
        }
    }
}

