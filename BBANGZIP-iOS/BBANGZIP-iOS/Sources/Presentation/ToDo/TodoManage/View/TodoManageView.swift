//
//  TodoManageView.swift
//  BBANGZIP
//
//  Created by 김송희 on 9/27/25.
//

import SwiftUI

struct TodoManageView: View {
    @ObservedObject var viewModel: TodoManageViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            titleSection
            
            subtitleSection
                .padding(.top, 4)
            
            actionButtons
                .padding(.top, 28)
            
            if !viewModel.isCompleted {
                startTimeSection
                    .padding(.top, 24)
                
                alertSection
                    .padding(.top, 20)
                
                divider
                    .padding(.vertical, 24)
                
                postponeSection
                
                duplicateSection
                    .padding(.top, 20)
                
                changeDateSection
                    .padding(.top, 20)
            } else {
                divider
                    .padding(.top, 20)
                
                repeatSection
                    .padding(.top, 28)
            }            
        }
        .padding(.horizontal, 20)
        .sheet(isPresented: $viewModel.isEditSheetPresented) {
            TodoContentEditView(
                originalTodo: viewModel.title,
                isPresented: $viewModel.isEditSheetPresented,
                onSave: { newTitle in
                    viewModel.title = newTitle
                }
            )
            .presentationDetents([.height(161)])
            .presentationCornerRadius(48)
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $viewModel.isStartTimeSheetPresented) {
            let vm = StartTimeViewModel(selectedTime: viewModel.startTimeDate)

            StartTimeView(
                viewModel: vm,
                isSheetPresented: $viewModel.isStartTimeSheetPresented
            ) { selectedDate in
                viewModel.startTimeDate = selectedDate
            }
            .presentationDetents([.height(454)])
            .presentationCornerRadius(48)
            .presentationDragIndicator(.visible)
        }

    }
}

private extension TodoManageView {
    var titleSection: some View {
        Text(viewModel.title)
            .bbangFont(.title3)
            .foregroundStyle(Color(.labelNormal))
            .lineLimit(1)
            .truncationMode(.tail)
    }
    
    var subtitleSection: some View {
        Text(viewModel.category)
            .bbangFont(.subtitle2)
            .foregroundStyle(Color(.labelAlternative))
    }
    
    var actionButtons: some View {
        HStack(spacing: 8) {
            Button("수정하기") {
                viewModel.isEditSheetPresented = true
            }
            .buttonStyle(
                BbangButtonStyle(
                    style: .light,
                    leftIcon: Image(.icPencil)
                )
            )
            
            Button("삭제하기") {
                // TODO: 투두 삭제
            }
            .buttonStyle(
                BbangButtonStyle(
                    style: .primary,
                    leftIcon: Image(.icTrash)
                )
            )
        }
    }
    
    var startTimeSection: some View {
        HStack(spacing: 0) {
            Image(.icClock)
                .renderingMode(.template)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(Color(.labelAlternative))
            
            Text("시작 시간")
                .bbangFont(.body2)
                .foregroundStyle(Color(.labelAlternative))
                .padding(.leading, 8)
            
            Spacer()
            
            Text(viewModel.formattedStartTime)
                .bbangFont(.body1)
                .foregroundStyle(viewModel.startTimeDate == nil ? Color(.labelAssistive) : Color(.labelAlternative))
            
            Image(.icChevronRight)
                .renderingMode(.template)
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundStyle(Color(.labelAlternative))
                .padding(.leading, 8)
        }
        .contentShape(Rectangle())
        .onTapGesture { viewModel.isStartTimeSheetPresented = true }
    }
    
    var alertSection: some View {
        HStack(spacing: 0) {
            Image(.icAlert)
                .renderingMode(.template)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(Color(.labelAlternative))
            
            Text("미룬이 알림")
                .bbangFont(.body2)
                .foregroundStyle(Color(.labelAlternative))
                .padding(.leading, 8)
            
            Spacer()
            
            Toggle("", isOn: $viewModel.isAlerted)
                .toggleStyle(SwitchToggleStyle(tint: Color(.primaryNormal)))
                .labelsHidden()
                .scaleEffect(0.8)
        }
    }
    
    var divider: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(Color(.secondaryNormal))
    }
    
    var postponeSection: some View {
        DefaultOptionRow(
            icon: Image(.icShare),
            title: "내일로 미루기",
            onTap: {
                // TODO: 내일로 미루기 액션
            }
        )
    }
    
    var duplicateSection: some View {
        DefaultOptionRow(
            icon: Image(.icCopy),
            title: "할 일 복제하기",
            onTap: {
                // TODO: 할 일 복제 액션
            }
        )
    }
    
    var changeDateSection: some View {
        DefaultOptionRow(
            icon: Image(.icCalendar),
            title: "날짜 바꾸기",
            onTap: {
                // TODO: 날짜 변경 액션
            }
        )
    }
    
    var repeatSection: some View {
        DefaultOptionRow(
            icon: Image(.icRepeat),
            title: "다른 날 또 하기",
            onTap: {
                // TODO: 날짜 선택 바텀시트 열기
            }
        )
    }
}

private struct DefaultOptionRow: View {
    let icon: Image
    let title: String
    var onTap: (() -> Void)? = nil
    
    var body: some View {
        HStack(spacing: 0) {
            icon
                .renderingMode(.template)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(Color(.labelAlternative))
            
            Text(title)
                .bbangFont(.body2)
                .foregroundStyle(Color(.labelAlternative))
                .padding(.leading, 8)
            
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTap?()
        }
    }
}
