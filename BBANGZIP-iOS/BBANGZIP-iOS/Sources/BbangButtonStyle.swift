//
//  BbangButtonStyle.swift
//  BBANGZIP
//
//  Created by 김송희 on 5/14/25.
//

import SwiftUI

struct BbangButtonStyle: ButtonStyle {
    private let style: BbangButtonType
    private let leftIcon: Image?
    private let rightIcon: Image?
    
    init (
        style: BbangButtonType,
        leftIcon: Image? = nil,
        rightIcon: Image? = nil
    ) {
        self.style = style
        self.leftIcon = leftIcon
        self.rightIcon = rightIcon
    }
    
    func makeBody(configuration: Configuration) -> some View {
        let (backgroundColor, foregroundColor): (Color, Color) = {
            switch style {
            case .primary:
                (Color(.primaryStrong), Color(.staticwhite))
            case .secondary:
                (Color(.primaryLight), Color(.staticwhite))
            case .disabled:
                (Color(.labelDisable), Color(.labelAssistive))
            }
        }()
        
        return HStack(spacing: 4) {
            if let leftIcon {
                leftIcon
                    .renderingMode(.template)
                    .resizable()
                    .foregroundColor(foregroundColor)
                    .frame(width: 16, height: 16)
            }
            
            configuration.label
                .bbangFont(.body2)
                .foregroundStyle(foregroundColor)
                .padding(.vertical, 14)
            
            if let rightIcon {
                rightIcon
                    .renderingMode(.template)
                    .resizable()
                    .foregroundColor(foregroundColor)
                    .frame(width: 16, height: 16)
            }
        }
        .frame(maxWidth: .infinity)
        .background(backgroundColor)
        .cornerRadius(32)
    }
}

#Preview {
    Button("30분 더") {}
        .buttonStyle(
            BbangButtonStyle(
                style: .secondary,
                leftIcon: Image(.icChevronLeft),
                rightIcon: Image(.icPlusThick)
            )
        )
        .padding(.horizontal, 50)
    
    Button("돌아가기") {}
        .buttonStyle(
            BbangButtonStyle(
                style: .primary,
                leftIcon: Image(.icRefreshThick)
            )
        )
        .padding(.horizontal, 100)
    
    Button("종료하기") {}
        .buttonStyle(
            BbangButtonStyle(
                style: .disabled,
                rightIcon: Image(.icQuit)
            )
        )
        .padding(.horizontal, 150)
}
