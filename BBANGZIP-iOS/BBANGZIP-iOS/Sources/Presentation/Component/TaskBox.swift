//
//  TaskBox.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/14/25.
//

import SwiftUI

struct TaskBox: View {
    var item: TimerTodo
    var meatballTapped: () -> Void
    var showSeperator: Bool = true
    var onToggleCompleted: (() -> Void)? = nil
    
    var body: some View {
        HStack(alignment: .center) {
            Checkbox(
                isChecked: item.isCompleted,
                color: item.colorType.color,
                onToggle: {
                    onToggleCompleted?()
                }
            )
            
            VStack(spacing: 0) {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(alignment: .center) {
                            Text(item.content)
                                .bbangFont(.body2)
                                .foregroundColor(Color(.labelNomal))
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                        }
                        
                        if let time = item.startTime,
                           let formattedTime = time.toAmPmFormattedTime() {
                            HStack(spacing: 3) {
                                Image(.icClock)
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(Color(.labelAssistive))
                                
                                Text(formattedTime)
                                    .bbangFont(.label4)
                                    .foregroundColor(Color(.labelAssistive))
                            }
                        }
                    }
                    .padding(.vertical, item.startTime == nil ? 13 : 10)
                    
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
