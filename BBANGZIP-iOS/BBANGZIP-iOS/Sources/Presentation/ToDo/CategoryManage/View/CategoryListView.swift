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
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderBarView(
                title: "카테고리 관리",
                leftIcon: .icChevronLeft,
                rightIcon: .icPlusThick
            )
            .padding(.bottom, 32)
            
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    ForEach(viewModel.categories) { category in
                        CategoryButton(
                            color: .constant(category.colorType.color),
                            labelText: .constant(category.name)
                        )
                    }
                }
                .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .task {
            await viewModel.fetchCategories()
        }
    }
    
    private struct HeaderBarView: View {
        let title: String
        let leftIcon: ImageResource
        let rightIcon: ImageResource
//        let onTapLeft: () -> Void
//        let onTapRight: () -> Void
        
        var body: some View {
            HStack {
                Button(action: {
                    // TODO: 뒤로가기
                }) {
                    Image(leftIcon)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 24, height: 24)
                }
                .foregroundStyle(Color(.labelAssistive))
                
                Spacer()
                
                Button(action: {
                    // TODO: 카테고리 추가 뷰 연결
                }) {
                    Image(rightIcon)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 24, height: 24)
                }
                .foregroundStyle(Color(.labelDisable))
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
}

#Preview {
    CategoryListView()
}
