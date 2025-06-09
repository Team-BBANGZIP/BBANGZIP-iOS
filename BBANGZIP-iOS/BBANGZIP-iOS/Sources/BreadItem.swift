//
//  BreadItem.swift
//  BBANGZIP
//
//  Created by 김송희 on 5/26/25.
//

import SwiftUI

struct BreadItem: View {
    let breadName: String
    let isUnlocked: Bool
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topLeading) {
                if isSelected {
                    Circle()
                        .fill(Color(.secondaryLight))
                        .frame(width: 88, height: 88)
                    
                    ZStack {
                        Circle()
                            .fill(Color(.primaryNormal))
                        
                        Image(.icCheck)
                            .renderingMode(.template)
                            .resizable()
                            .foregroundColor(Color(.staticwhite))
                    }
                    .frame(width: 24, height: 24)
                }
                
                if isUnlocked {
                    breadImage(for: breadName)
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 7)
                        .padding(.vertical, 17)
                } else {
                    breadImage(for: breadName)
                        .resizable()
                        .scaledToFit()
                        .padding(.all, 24)
                        .padding(.vertical, 4)
                }
            }
            
            Spacer()

            Text(breadName)
                .bbangFont(.body2)
                .foregroundColor(Color(.labelNormal))
        }
        .frame(width: 80, height: 116)
    }

    func breadImage(for name: String) -> Image {
        switch name {
        case "소금빵":
            // TODO: 서버에서 이미지 받아오도록 API 연결
            return Image(.itemSaltBread)
        default:
            return Image(.itemLocked)
        }
    }
}

#Preview {
    HStack(spacing: 24) {
        BreadItem(
            breadName: "소금빵",
            isUnlocked: true,
            isSelected: true
        )
        
        BreadItem(
            breadName: "???",
            isUnlocked: false,
            isSelected: false
        )
    }
}
