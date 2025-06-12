//
//  TaskAddView.swift
//  BBANGZIP
//
//  Created by 김송희 on 6/12/25.
//

import SwiftUI

struct TaskAddView: View {
    @ObservedObject var viewModel: TaskAddViewModel
    @Binding var isPresented: Bool
    
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
                .padding(.top, 16)            
        }
        .padding(.horizontal, 20)
    }
    
    // TODO: 시간 설정 바텀시트 오픈
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
            
            Text("미설정")
                .bbangFont(.body2)
                .foregroundStyle(Color(.labelAssistive))
                .padding(.trailing, 8)
            
            Image(.icChevronRight)
                .renderingMode(.template)
                .resizable()
                .foregroundStyle(Color(.labelAssistive))
                .frame(width: 20, height: 20)
        }
    }
}
