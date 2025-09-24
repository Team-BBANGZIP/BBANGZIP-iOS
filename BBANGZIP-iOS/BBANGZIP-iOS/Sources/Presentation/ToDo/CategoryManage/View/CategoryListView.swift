//
//  CategoryListView.swift
//  BBANGZIP
//
//  Created by 김송희 on 9/2/25.
//

import SwiftUI

struct CategoryListView: View {
    @ObservedObject var viewModel: CategoryListViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isNavigatingToAddView = false
    @Binding var navigationPath: NavigationPath
    
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
                Categories(
                    viewModel: viewModel,
                    navigationPath: $navigationPath
                )
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
                    .frame(width: 28, height: 28)
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

private struct Categories: View {
    @ObservedObject var viewModel: CategoryListViewModel
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 20) {
            if !viewModel.activeCategories.isEmpty {
                ForEach(viewModel.activeCategories) { category in
                    CategoryButton(
                        color: .constant(category.colorType.color),
                        labelText: .constant(category.name),
                        showsPlusIcon: false
                    )
                    .onTapGesture {
                        navigationPath.append(category)
                    }
                }
            }
            
            if !viewModel.stoppedCategories.isEmpty {
                Text("종료한 카테고리")
                    .bbangFont(.label6)
                    .foregroundStyle(Color(.labelAlternative))
                    .padding(.top, 20)
                    .padding(.bottom, -8)
                
                ForEach(viewModel.stoppedCategories) { category in
                    CategoryButton(
                        color: .constant(category.colorType.color),
                        labelText: .constant(category.name),
                        showsPlusIcon: false
                    )
                    .onTapGesture{
                        navigationPath.append(category)
                    }
                }
            }
        }
    }
}
