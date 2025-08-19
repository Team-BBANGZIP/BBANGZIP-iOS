//
//  TaskBox.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/14/25.
//

import SwiftUI

struct TaskBox: View {
    @ObservedObject var viewModel: TimerTodoViewModel
    var meatballTapped: () -> Void
    var showSeperator: Bool = true
    
    var body: some View {
        HStack(alignment: .center) {
            CheckBox(
                isChecked: viewModel.todo.isCompleted,
                color: viewModel.todo.colorType.color,
                onToggle: {
                    viewModel.toggleCompletion()
                }
            )
            
            VStack(spacing: 0) {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(viewModel.todo.content)
                                .bbangFont(.body2)
                                .foregroundColor(Color(.labelNormal))
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        
                        if let time = viewModel.todo.startTime,
                           let formattedTime = time.toAmPmFormattedTime() {
                            HStack(spacing: 3) {
                                Image(.icClock)
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(Color(.labelAssistive))
                                Text(formattedTime)
                                    .bbangFont(.label4)
                                    .foregroundColor(Color(.labelAssistive))
                            }
                        }
                    }
                    .padding(.vertical, viewModel.todo.startTime == nil ? 13 : 10)
                    
                    Button(action: meatballTapped) {
                        Image(.icMeatball)
                            .renderingMode(.template)
                            .foregroundColor(Color(.secondaryStrong))
                    }
                }
                
                if showSeperator {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color(.secondaryNormal))
                }
            }
        }
    }
}
