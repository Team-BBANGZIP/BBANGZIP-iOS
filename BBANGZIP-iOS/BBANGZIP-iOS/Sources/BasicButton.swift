//
//  Button.swift
//  BBANGZIP
//
//  Created by 김송희 on 5/14/25.
//

import SwiftUI

struct BasicButtonStyle: ButtonStyle {
    let backgroundColor: Color
    let foregroundColor: Color
    let leftIcon: Image?
    let rightIcon: Image?
    
    init (
        backgroundColor: Color,
        foregroundColor: Color,
        leftIcon: Image? = nil,
        rightIcon: Image? = nil
    ) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.leftIcon = leftIcon
        self.rightIcon = rightIcon
    }
    
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 4) {
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

struct SecondaryButton: ButtonStyle {
    private let leftIcon: Image?
    private let rightIcon: Image?
    
    init(
        leftIcon: Image? = nil,
        rightIcon: Image? = nil
    ) {
        self.leftIcon = leftIcon
        self.rightIcon = rightIcon
    }
    
    func makeBody(configuration: Configuration) -> some View {
        BasicButtonStyle(
            backgroundColor: Color(.primaryNormal),
            foregroundColor: Color(.staticwhite),
            leftIcon: leftIcon,
            rightIcon: rightIcon
        ).makeBody(configuration: configuration)
    }
}

struct PrimaryButton: ButtonStyle {
    private let leftIcon: Image?
    private let rightIcon: Image?
    
    init(
        leftIcon: Image? = nil,
        rightIcon: Image? = nil
    ) {
        self.leftIcon = leftIcon
        self.rightIcon = rightIcon
    }
    
    func makeBody(configuration: Configuration) -> some View {
        BasicButtonStyle(
            backgroundColor: Color(.primaryStrong),
            foregroundColor: Color(.staticwhite),
            leftIcon: leftIcon,
            rightIcon: rightIcon
        ).makeBody(configuration: configuration)
    }
}

struct DisabledButton: ButtonStyle {
    private let leftIcon: Image?
    private let rightIcon: Image?
    
    init(
        leftIcon: Image? = nil,
        rightIcon: Image? = nil
    ) {
        self.leftIcon = leftIcon
        self.rightIcon = rightIcon
    }
    
    func makeBody(configuration: Configuration) -> some View {
        BasicButtonStyle(
            backgroundColor: Color(.labelDisable),
            foregroundColor: Color(.labelAssistive),
            leftIcon: leftIcon,
            rightIcon: rightIcon
        ).makeBody(configuration: configuration)
    }
}

#Preview {
    Button("30분 더") {}
        .buttonStyle(
            SecondaryButton(
                leftIcon: Image(.icChevronLeft),
                rightIcon: Image(.icPlusThick)
            ))
        .padding(.horizontal, 50)
    
    Button("돌아가기") {}
        .buttonStyle(PrimaryButton(
            leftIcon: Image(.icRefreshThick)
        ))
        .padding(.horizontal, 100)
    
    Button("종료하기") {}
        .buttonStyle(DisabledButton(
            rightIcon: Image(.icQuit)
        ))
        .padding(.horizontal, 150)
}
