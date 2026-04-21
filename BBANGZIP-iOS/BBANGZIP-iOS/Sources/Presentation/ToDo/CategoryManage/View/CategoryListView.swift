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
    
    @State private var draggingId: Int?
    @State private var dragCurrentIndex: Int?
    @State private var dragOffset: CGFloat = 0
    @State private var accumulatedOffset: CGFloat = 0
    @State private var isDragActive = false
    
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
            
            VStack(alignment: .leading, spacing: 0) {
                if !viewModel.activeCategories.isEmpty {
                    let ids = viewModel.activeCategories.map(\.id)
                    ForEach(Array(viewModel.activeCategories.enumerated()), id: \.element.id) { index, category in
                        let isDragging = draggingId == category.id
                        
                        categoryRow(category: category)
                            .offset(y: isDragging ? dragOffset : 0)
                            .scaleEffect(isDragging ? 1.03 : 1.0)
                            .zIndex(isDragging ? 1 : 0)
                            .onTapGesture {
                                guard !isDragActive else { return }
                                navigationPath.append(category)
                            }
                            .simultaneousGesture(
                                LongPressGesture(minimumDuration: 0.4)
                                    .sequenced(before: DragGesture(minimumDistance: 0))
                                    .onChanged { value in
                                        switch value {
                                        case .second(true, let drag):
                                            if draggingId == nil {
                                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                                draggingId = category.id
                                                dragCurrentIndex = index
                                                accumulatedOffset = 0
                                                isDragActive = true
                                            }
                                            
                                            guard draggingId == category.id,
                                                  let drag = drag,
                                                  let fromIndex = dragCurrentIndex else { return }
                                            
                                            dragOffset = drag.translation.height
                                            
                                            let net = dragOffset - accumulatedOffset
                                            let steps = Int((net / rowHeight).rounded())
                                            let toIndex = min(max(fromIndex + steps, 0), viewModel.activeCategories.count - 1)
                                            
                                            if toIndex != fromIndex {
                                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                                viewModel.reorderActiveCategory(from: fromIndex, to: toIndex)
                                                accumulatedOffset += CGFloat(toIndex - fromIndex) * rowHeight
                                                dragCurrentIndex = toIndex
                                            }
                                        default:
                                            break
                                        }
                                    }
                                    .onEnded { _ in
                                        dragOffset = 0
                                        draggingId = nil
                                        dragCurrentIndex = nil
                                        accumulatedOffset = 0
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                            isDragActive = false
                                        }
                                    }
                            )
                    }
                    .animation(.easeInOut(duration: 0.7), value: ids)
                }
                
                if !viewModel.stoppedCategories.isEmpty {
                    Text("종료한 카테고리")
                        .bbangFont(.label6)
                        .foregroundStyle(Color(.labelAlternative))
                        .padding(.top, 32)
                        .padding(.bottom, 12)
                        .padding(.horizontal, 20)
                    
                    ForEach(viewModel.stoppedCategories) { category in
                        categoryRow(category: category)
                            .onTapGesture {
                                navigationPath.append(category)
                            }
                    }
                }
            }
            
            Spacer()
        }
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            Task {
                await viewModel.fetchCategories()
            }
        }
    }
    
    private func categoryRow(category: Category) -> some View {
        HStack {
            CategoryButton(
                color: .constant(category.colorType.color),
                labelText: .constant(category.name),
                showsPlusIcon: false
            )
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .frame(height: rowHeight)
        .contentShape(Rectangle())
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
