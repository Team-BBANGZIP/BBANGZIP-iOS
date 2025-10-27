//
//  SettingToggleStyle.swift
//  BBANGZIP
//
//  Created by 최유빈 on 10/7/25.
//

import SwiftUI

struct SettingToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 32)
                .fill(Color(.componentStrong))
                .frame(width: 44, height: 24)
                .overlay(
                    Circle()
                        .fill(configuration.isOn ? Color(.primaryNormal) : Color(.labelAssistive))
                        .padding(1)
                        .offset(x: configuration.isOn ? 10 : -10)
                        .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
                )
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}
