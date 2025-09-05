//
//  TaskAddView.swift
//  BBANGZIP
//
//  Created by 김송희 on 6/12/25.
//

import Foundation
import SwiftUI

struct TaskAddView: View {
    @ObservedObject var viewModel: TaskAddViewModel
    @Binding var isPresented: Bool
    @State private var isStartTimeSheetPresented: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            Text("할 일 추가")
                .bbangFont(.title3)
                .foregroundStyle(Color(.labelAlternative))
                .padding(.top, 25)
            
            TaskInputField(text: $viewModel.newTaskText) {
                viewModel.submitTask()
                isPresented = false
            }
            .padding(.top, 31)
            .padding(.bottom, 16)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(.secondaryNormal))
            
            startTime
                .contentShape(Rectangle())
                .onTapGesture {
                    isStartTimeSheetPresented = true
                }
                .padding(.top, 16)
        }
        .padding(.horizontal, 20)
        .onDisappear {
            viewModel.submitTask()
        }
        .sheet(isPresented: $isStartTimeSheetPresented) {
            let startTimeViewModel = StartTimeViewModel(selectedTime: viewModel.startTime)
            
            if #available(iOS 16.4, *) {
                StartTimeView(
                    viewModel: startTimeViewModel,
                    isSheetPresented: $isStartTimeSheetPresented
                ) { selected in
                    viewModel.startTime = selected
                }
                .presentationDetents([.height(454)])
                .presentationCornerRadius(48)
                .presentationDragIndicator(.visible)
            } else {
                StartTimeView(
                    viewModel: startTimeViewModel,
                    isSheetPresented: $isStartTimeSheetPresented
                ){ selected in
                    viewModel.startTime = selected
                }
                .presentationDetents([.height(454)])
                .presentationDragIndicator(.visible)
            }
        }
    }
    
    var startTime: some View {
        HStack(spacing: 0) {
            Image(.icClock)
                .renderingMode(.template)
                .foregroundStyle(Color(.labelAlternative))
            
            Text("시작 시간")
                .bbangFont(.body2)
                .foregroundStyle(Color(.labelAlternative))
                .padding(.leading, 8)
            
            Spacer()
            
            Text(viewModel.startTime.map {formatDate($0)} ?? "미설정")
                .bbangFont(.body2)
                .foregroundStyle(viewModel.startTime == nil ? Color(.labelAssistive) : Color(.labelAlternative))
                .padding(.trailing, 8)
            
            Image(.icChevronRight)
                .renderingMode(.template)
                .resizable()
                .foregroundStyle(Color(.labelAssistive))
                .frame(width: 20, height: 20)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        Foundation.DateFormatter.taskTimeFormatter.string(from: date)
    }
}
