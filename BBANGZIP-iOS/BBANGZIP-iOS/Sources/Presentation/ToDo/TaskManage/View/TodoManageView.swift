//
//  TodoManageView.swift
//  BBANGZIP
//
//  Created by 김송희 on 9/27/25.
//

import SwiftUI

struct TodoManageView: View {
    @Binding var todo: String
    @Binding var category: String
    @Binding var startTime: String?
    @Binding var isAlerted: Bool
    
    @State private var isEditSheetPresented = false
    @State private var isStartTimeSheetPresented = false
    
    var body: some View {
        VStack(spacing: 0) {
            titleSection
            
            subtitleSection
                .padding(.top, 4)
            
            actionButtons
                .padding(.top, 28)
            
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
        }
        .padding(.horizontal, 20)
        .sheet(isPresented: $isEditSheetPresented) {
            TodoContentEditView(
                viewModel: {
                    let vm = TodoContentEditViewModel { newTitle in
                        self.todo = newTitle
                    }
                    vm.newTodo = self.todo
                    return vm
                }(),
                isPresented: $isEditSheetPresented
            )
            .presentationDetents([.height(161)])
            .presentationCornerRadius(48)
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $isStartTimeSheetPresented) {
            let selectedDate = startTime.flatMap { TimeFormatters.input.date(from: $0) }
            let vm = StartTimeViewModel(selectedTime: selectedDate)

            StartTimeView(
                viewModel: vm,
                isSheetPresented: $isStartTimeSheetPresented
            ) { selectedDate in
                startTime = selectedDate.map { TimeFormatters.input.string(from: $0) }
            }
            .onReceive(vm.$tempTime) { date in
                startTime = TimeFormatters.input.string(from: date)
            }
            .presentationDetents([.height(454)])
            .presentationCornerRadius(48)
            .presentationDragIndicator(.visible)
        }

    }
}

private extension TodoManageView {
    var titleSection: some View {
        Text(todo)
            .bbangFont(.title3)
            .foregroundStyle(Color(.labelNormal))
    }
    
    var subtitleSection: some View {
        Text(category)
            .bbangFont(.subtitle2)
            .foregroundStyle(Color(.labelAlternative))
    }
    
    var actionButtons: some View {
        HStack(spacing: 8) {
            Button("수정하기") {
                isEditSheetPresented = true
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
            
            Text(formattedStartTime)
                .bbangFont(.body1)
                .foregroundStyle(startTime == nil ? Color(.labelAssistive) : Color(.labelAlternative))
            
            Image(.icChevronRight)
                .renderingMode(.template)
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundStyle(Color(.labelAlternative))
                .padding(.leading, 8)
        }
        .contentShape(Rectangle())
        .onTapGesture { isStartTimeSheetPresented = true }
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
            
            Toggle("", isOn: $isAlerted)
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
    
    private var formattedStartTime: String {
        guard let raw = startTime,
              let date = TimeFormatters.input.date(from: raw) else {
            return startTime ?? "미설정"
        }
        return TimeFormatters.output.string(from: date)
    }
    
    private enum TimeFormatters {
        static let input: DateFormatter = {
            let df = DateFormatter()
            df.locale = Locale(identifier: "en_US_POSIX")
            df.dateFormat = "HH:mm"
            return df
        }()
        
        static let output: DateFormatter = {
            let df = DateFormatter()
            df.locale = Locale(identifier: "en_US_POSIX")
            df.dateFormat = "a h:mm"
            df.amSymbol = "AM"
            df.pmSymbol = "PM"
            return df
        }()
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

#Preview {
    TodoManageView(
        todo: .constant("7차 세미나 장표 제작"),
        category: .constant("SOPT"),
        startTime: .constant("09:00"),
        isAlerted: .constant(true)
    )
}
