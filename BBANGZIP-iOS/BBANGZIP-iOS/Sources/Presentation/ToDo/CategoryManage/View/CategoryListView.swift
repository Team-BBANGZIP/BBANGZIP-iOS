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
        .navigationBarHidden(true)
        .onAppear {
            Task {
                await viewModel.fetchCategories()
            }
        }
        .navigationDestination(isPresented: $isNavigatingToAddView) {
            CategoryAddView()
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
            
            if !viewModel.activeCategories.isEmpty {
                ForEach(viewModel.activeCategories) { category in
                    NavigationLink {
                        
                        // TODO: persist는 로컬 레포용이므로 서버 연결 후 삭제
                        CategoryManageView(
                            category: category,
                            onSaved: { updated in
                                withAnimation(.spring()) {
                                    viewModel.updateCategory(updated)
                                }
                                Task { await viewModel.persistCategory(updated) }
                            },
                            onDeleted: { id in
                                withAnimation(.spring()) {
                                    viewModel.removeCategory(id: id)
                                }
                                Task { await viewModel.persistDeleteCategory(id: id) }
                            }
                        )
                    } label: {
                        CategoryButton(
                            color: .constant(category.colorType.color),
                            labelText: .constant(category.name)
                        )
                    }
                }
            }
            
            if !viewModel.stoppedCategories.isEmpty {
                Text("종료한 카테고리")
                    .bbangFont(.body2)
                    .foregroundStyle(Color(.labelAssistive))
                
                ForEach(viewModel.stoppedCategories) { category in
                    NavigationLink {
                        
                        // TODO: persist는 로컬 레포용이므로 서버 연결 후 삭제
                        CategoryManageView(
                            category: category,
                            onSaved: { updated in
                                withAnimation(.spring()) {
                                    viewModel.updateCategory(updated)                                }
                                Task { await viewModel.persistCategory(updated) }
                            },
                            onDeleted: { id in
                                withAnimation(.spring()) {
                                    viewModel.removeCategory(id: id)
                                }
                                Task { await viewModel.persistDeleteCategory(id: id) }
                            }
                        )
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
