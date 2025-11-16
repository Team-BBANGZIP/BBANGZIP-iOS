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
    @Binding var navigationPath: NavigationPath
    @State private var draggingCategoryId: Int?
    @State private var dragCurrentIndex: Int?
    @State private var dragTranslation: CGFloat = 0
    private let rowHeight: CGFloat = 52
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderBarView(
                title: "카테고리 관리",
                leftIcon: .icChevronLeft,
                rightIcon: .icPlusThick,
                onTapLeft: {
                    Task {
                        await viewModel.persistCategoryOrderIfNeeded()
                        dismiss()
                    }
                },
                onTapRight: {
                    Task {
                        await viewModel.persistCategoryOrderIfNeeded()
                        navigationPath.append("CategoryAdd")
                    }
                }
            )
            .padding(.bottom, 32)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    if !viewModel.activeCategories.isEmpty {
                        ForEach(Array(viewModel.activeCategories.enumerated()), id: \.element.id) { index, category in
                            let isDragging = draggingCategoryId == category.id
                            
                            CategoryButton(
                                color: .constant(category.colorType.color),
                                labelText: .constant(category.name),
                                showsPlusIcon: false
                            )
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 4)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                navigationPath.append(category)
                            }
                            .offset(y: isDragging ? dragTranslation : 0)
                            .scaleEffect(isDragging ? 1.02 : 1.0)
                            .opacity(isDragging ? 0.95 : 1.0)
                            .zIndex(isDragging ? 1 : 0)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        if draggingCategoryId == nil {
                                            draggingCategoryId = category.id
                                            dragCurrentIndex = index
                                        }
                                        
                                        guard draggingCategoryId == category.id else { return }
                                        
                                        dragTranslation = value.translation.height
                                        
                                        guard let fromIndex = dragCurrentIndex else { return }
                                        
                                        var toIndex = fromIndex + Int((dragTranslation / rowHeight).rounded())
                                        toIndex = max(0, min(viewModel.activeCategories.count - 1, toIndex))
                                        
                                        guard toIndex != fromIndex else { return }
                                        
                                        let generator = UIImpactFeedbackGenerator(style: .rigid)
                                        generator.impactOccurred()
                                        
                                        withAnimation(.spring(response: 0.25,
                                                              dampingFraction: 0.85)) {
                                            viewModel.reorderActiveCategory(
                                                from: fromIndex,
                                                to: toIndex
                                            )
                                        }
                                        
                                        dragCurrentIndex = toIndex
                                    }
                                    .onEnded { _ in
                                        withAnimation(.spring(response: 0.25,
                                                              dampingFraction: 0.85)) {
                                            dragTranslation = 0
                                        }
                                        draggingCategoryId = nil
                                        dragCurrentIndex = nil
                                    }
                            )
                        }
                    }
                    
                    if !viewModel.stoppedCategories.isEmpty {
                        Text("종료한 카테고리")
                            .bbangFont(.label6)
                            .foregroundStyle(Color(.labelAlternative))
                            .padding(.top, 20)
                            .padding(.bottom, -8)
                            .padding(.horizontal, 20)
                        
                        ForEach(viewModel.stoppedCategories) { category in
                            CategoryButton(
                                color: .constant(category.colorType.color),
                                labelText: .constant(category.name),
                                showsPlusIcon: false
                            )
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 4)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                navigationPath.append(category)
                            }
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            Task {
                await viewModel.fetchCategories()
            }
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
