//
//  ToggleButton.swift
//  BBANGZIP
//
//  Created by 최유빈 on 5/13/25.
//

import SwiftUI

struct TimerToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: configuration.isOn ? .trailing : .leading) {
            RoundedRectangle(cornerRadius: 15)
                .frame(width: 96, height: 28)
                .foregroundColor(Color(.secondaryStrong))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(
                            Color(.toggleInnerShadow),
                            lineWidth: 1
                        )
                        .blur(radius: 1)
                        .offset(x: 0,y: 0.87)
                        .mask(RoundedRectangle(cornerRadius: 15))
                )
            
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 47, height: 26)
                    .foregroundColor(Color(.primaryNormal))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(
                                Color(.toggleButtonShadow),
                                lineWidth: 0.3
                            )
                            .blur(radius: 1)
                            .offset(x: 0,y: 1)
                            .mask(
                                RoundedRectangle(cornerRadius: 15).frame(width: 47,height: 26)
                            )
                    )
                    .shadow(
                        color: Color(.toggleDropShadow),
                        radius: 2,
                        x: 1,
                        y: 1
                    )
                
                configuration.isOn ? Text("60분")
                    .bbangFont(BbangzipFont.body4)
                    .foregroundColor(Color(.staticwhite)) : Text("30분")
                    .bbangFont(BbangzipFont.body4)
                    .foregroundColor(Color(.staticwhite))
            }
            .padding(.horizontal, 1)
            
            HStack(spacing: 0) {
                if configuration.isOn {
                    Text("30분")
                        .bbangFont(BbangzipFont.label4)
                        .foregroundColor(Color(.primaryNormal))
                        .frame(width: 48, height: 28)
                }
                
                Spacer()
                
                if !configuration.isOn {
                    Text("60분")
                        .bbangFont(BbangzipFont.label4)
                        .foregroundColor(Color(.primaryNormal))
                        .frame(width: 48, height: 28)
                }
            }
            .frame(width: 96, height: 28)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                configuration.isOn.toggle()
            }
        }
    }
}

struct ToggleButton: View {
    @Binding var isToggleOn: Bool
    
    var body: some View {
        Toggle(isOn: $isToggleOn) { }
            .toggleStyle(TimerToggleStyle())
    }
}

#Preview {
    ToggleButton(isToggleOn: Binding<Bool>.constant(false))
}
