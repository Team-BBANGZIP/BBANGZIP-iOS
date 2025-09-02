//
//  CategoryListView.swift
//  BBANGZIP
//
//  Created by 김송희 on 9/2/25.
//

import SwiftUI

struct CategoryListView: View {
    @StateObject private var viewModel = CategoryListViewModel(
        repository: MockTodoRepository()
    )
    @Environment(\.dismiss) private var dismiss
    @State private var isNavigatingToAddView = false
    @State private var selectedCategory: Category?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HeaderBarView(
                    title: "카테고리 관리",
                    leftIcon: .icChevronLeft,
                    rightIcon: .icPlusThick,
                    onTapLeft: { dismiss() },
                    onTapRight: { isNavigatingToAddView = true }
                )
                .padding(.bottom, 32)
                
                ScrollView {
                    Categories
                        .padding(.horizontal, 20)
                }
                
                Spacer()
            }
            .onAppear {
                Task {
                    await viewModel.fetchCategories()
                }
            }
            .navigationDestination(isPresented: $isNavigatingToAddView) {
                CategoryAddView()
            }
        }
    }
    
    private struct HeaderBarView: View {
        let title: String
        let leftIcon: ImageResource
        let rightIcon: ImageResource
        let onTapLeft: () -> Void
        let onTapRight: () -> Void
        
        var body: some View {
            HStack {
                Button(action: {
                    onTapLeft()
                }) {
                    Image(leftIcon)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 24, height: 24)
                }
                .foregroundStyle(Color(.labelAssistive))
                
                Spacer()
                
                Button(action: {
                    onTapRight()
                }) {
                    Image(rightIcon)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 24, height: 24)
                }
                .foregroundStyle(Color(.labelAssistive))
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 12)
            .overlay {
                Text(title)
                    .bbangFont(.title2)
                    .foregroundStyle(Color(.labelNormal))
                    .allowsHitTesting(false)
            }
        }
    }
    
    var Categories: some View {
        LazyVStack(alignment: .leading, spacing: 20) {
            
            let active = viewModel.categories.filter { !$0.isStopped }
            if !active.isEmpty {
                ForEach(active) { category in
                    NavigationLink {
                        CategoryManageView(category: category) { updated in
                            viewModel.updateCategory(updated)
                        }
                    } label: {
                        CategoryButton(
                            color: .constant(category.colorType.color),
                            labelText: .constant(category.name)
                        )
                    }
                }
            }
            
            let stopped = viewModel.categories.filter { $0.isStopped }
            if !stopped.isEmpty {
                Text("종료한 카테고리")
                    .bbangFont(.body2)
                    .foregroundStyle(Color(.labelAssistive))
                
                ForEach(stopped) { category in
                    NavigationLink {
                        CategoryManageView(category: category) { updated in
                            viewModel.updateCategory(updated)
                        }
                    } label: {
                        CategoryButton(
                            color: .constant(category.colorType.color),
                            labelText: .constant(category.name)
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    CategoryListView()
}
