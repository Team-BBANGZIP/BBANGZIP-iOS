//
//  TaskBox.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/14/25.
//

import SwiftUI

struct TaskBox: View {
    @Binding var item: TodoItem
    var onMoreTapped: () -> Void
    var showSeperator: Bool = true
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Checkbox(isChecked: $item.isCompleted)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .center) {
                    Text(item.content)
                        .bbangFont(.body2)
                        .foregroundColor(Color(.labelNomal))
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                    
                    Button(action: onMoreTapped) {
                        Image(.icMeatball)
                            .renderingMode(.template)
                            .foregroundColor(Color(.secondaryStrong))
                    }
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
                
                if showSeperator {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color(.secondaryNormal))
                        .padding(.top, 6)
                }
            }
        }
    }
}

///사용법 예시
struct TaskBox_Previews: PreviewProvider {
    @State static var mockItem1 = TodoItem(
        todoId: 1,
        content: "저녁 메뉴 추천해주세요! 배고픈데 신전떡볶이나 먹을까 고민되네 진짜 날은 또 왜이리 좋아",
        isCompleted: true,
        startTime: "14:00"
    )
    
    @State static var mockItem2 = TodoItem(
        todoId: 2,
        content: "회의 준비사항 정리해서 Notion에 업로드하기",
        isCompleted: false,
        startTime: "10:30"
    )
    
    @State static var mockItem3 = TodoItem(
        todoId: 3,
        content: "LLM 모델 정리하기",
        isCompleted: false,
        startTime: nil
    )
    
    static var previews: some View {
        VStack(spacing: 16) {
            TaskBox(item: $mockItem1, onMoreTapped: {
                print("미트볼 1 눌림")
            }, showSeperator: true)
            
            TaskBox(item: $mockItem2, onMoreTapped: {
                print("미트볼 2 눌림")
            }, showSeperator: true)
            
            TaskBox(item: $mockItem3, onMoreTapped: {
                print("미트볼 3 눌림")
            }, showSeperator: false)
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
