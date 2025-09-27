//
//  TodoMeatballSheet.swift
//  BBANGZIP
//
//  Created by 김송희 on 9/27/25.
//

import SwiftUI

struct TodoMeatballSheet: View {
    @Binding var isAlerted: Bool
    
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
    }
}

private extension TodoMeatballSheet {
    var titleSection: some View {
        Text("7차 세미나 장표 제작")
            .bbangFont(.title3)
            .foregroundStyle(Color(.labelNormal))
    }
    
    var subtitleSection: some View {
        Text("SOPT")
            .bbangFont(.subtitle2)
            .foregroundStyle(Color(.labelAlternative))
    }
    
    var actionButtons: some View {
        HStack(spacing: 8) {
            Button("수정하기") {
                // TODO: 투두 수정
            }
            .buttonStyle(
                BbangButtonStyle(
                    style: .light,
                    leftIcon: Image(.icTrash)
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
            
            Text("AM 09:00")
                .bbangFont(.body1)
                .foregroundStyle(Color(.labelAlternative))
            
            Image(.icChevronRight)
                .renderingMode(.template)
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundStyle(Color(.labelAlternative))
                .padding(.leading, 8)
        }
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
    TodoMeatballSheet(
        isAlerted: .constant(true)
    )
}
