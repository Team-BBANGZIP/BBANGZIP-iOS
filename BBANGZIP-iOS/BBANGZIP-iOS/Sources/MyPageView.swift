//
//  MyPageView.swift
//  BBANGZIP
//
//  Created by 최유빈 on 10/1/25.
//

import SwiftUI

struct MyPageView: View {
    var body: some View {
        ZStack {
            Color(.secondaryLight)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack {
                    ProfileSection
                        .padding(.top, 32)
                    
                    SettingSection
                        .padding(.top, 32)
                }
            }
        }
    }
    
    private var ProfileSection: some View {
        VStack(spacing: 20) {
            HStack {
                BbangText(
                    "프로필",
                    font: .title1,
                    color: Color(.labelStrong)
                )
                .padding(.leading, 20)
                
                Spacer()
            }
            
            HStack(spacing: 12) {
                Image(.icProfile)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .clipShape(.circle)
                
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 0) {
                        BbangText(
                            "유나쨩",
                            font: .title4,
                            color: Color(.labelStrong)
                        )
                        
                        Button(action: {
                            
                        }) {
                            Image(.icPencil)
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(Color(.labelAssistive))
                        }
                    }
                    
                    BbangText(
                        "지금 이 순간 쌓는 한 줄의 지식이, 내일의 너를 강하게 만든다",
                        font: .subtitle1,
                        color: Color(.labelAlternative)
                    )
                    .lineLimit(1)
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var SettingSection: some View {
        ZStack {
            Color(.backgroundNomal)
                .cornerRadius(30)
        }
        .frame(height: 1000)
    }
}

#Preview {
    MyPageView()
}

