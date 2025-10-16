//
//  SettingScreenView.swift
//  BBANGZIP
//
//  Created by 최유빈 on 10/6/25.
//

import SwiftUI

struct SettingScreenView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("startWeekOnSunday") private var startWeekOnSunday: Bool = false
    
    var onDismiss: (() -> Void)?
    
    var body: some View {
        VStack {
            HeaderBarView(
                title: "화면 설정",
                leftIcon: .icChevronLeft,
                onTapLeft: {
                    onDismiss?()
                    dismiss()
                }
            )
            .navigationBarHidden(true)
            
            Toggle(isOn: $startWeekOnSunday) {
                BbangText(
                    "주 시작 요일 일요일로 설정",
                    font: .body2,
                    color: Color(.labelNormal)
                )
            }
            .toggleStyle(SettingToggleStyle())
            .padding(.top, 20)
            .padding(.horizontal, 20)
            
            HStack {
                BbangText(
                    "캘린더의 주 시작 요일을\n월요일에서 일요일로 변경할 수 있어요",
                    font: .body3,
                    color: Color(.labelAssistive)
                )
                .padding(.leading, 20)
                
                Spacer()
            }
            
            Spacer()
        }
    }
}

private struct HeaderBarView: View {
    let title: String
    let leftIcon: ImageResource
    let onTapLeft: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onTapLeft) {
                Image(leftIcon)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 28, height: 28)
            }
            .foregroundStyle(Color(.labelAssistive))
            
            Spacer()
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

#Preview {
    SettingScreenView()
}
