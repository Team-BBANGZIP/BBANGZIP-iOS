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
                color: item.color,
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


///사용법 예시
//struct TaskBoxPreviewWrapper: View {
//    @State var item: TodoItem
//    var showSeperator: Bool = true
//
//    var body: some View {
//        TaskBox(
//            item: $item,
//            meatballTapped: {
//                print("미트볼 버튼 눌림")
//            },
//            showSeperator: showSeperator,
//            onToggleCompleted: {
//                print("상태 바뀜: \($0)")
//            }
//        )
//    }
//}
//
//struct TaskBox_Previews: PreviewProvider {
//    static var previews: some View {
//        VStack(spacing: 0) {
//            TaskBoxPreviewWrapper(item: TodoItem(
//                todoId: 1,
//                content: "디자인 회의 참석 스타벅스엔 하루종일 사람이 많다 하지만 비싸다 가격을 내려주세요 ㅋㅋ",
//                isCompleted: true,
//                startTime: "10:00"
//            ), showSeperator: true)
//
//            TaskBoxPreviewWrapper(item: TodoItem(
//                todoId: 2,
//                content: "기획안 작성 및 팀 노션 업데이트",
//                isCompleted: false,
//                startTime: "14:30"
//            ))
//
//            TaskBoxPreviewWrapper(item: TodoItem(
//                todoId: 3,
//                content: "LLM 기반 챗봇 아키텍처 정리",
//                isCompleted: false,
//                startTime: nil
//            ))
//        }
//        .previewLayout(.sizeThatFits)
//        .padding()
//    }
//}
