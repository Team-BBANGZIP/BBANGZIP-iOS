//
//  BreadItem.swift
//  BBANGZIP
//
//  Created by 김송희 on 5/26/25.
//

import SwiftUI

struct BreadItem: View {
    let breadId: Int
    let breadName: String
    let isUnlocked: Bool
    let requiredCount: Int
    let imageUrl: String
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
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .padding(.horizontal, 7)
                    .padding(.vertical, 17)
                } else {
                    Image(.itemLocked)
                        .resizable()
                        .scaledToFit()
                        .padding(.all, 24)
                        .padding(.vertical, 4)
                }
            }

            Spacer()

            Text(isUnlocked ? breadName : "???")
                .bbangFont(.body2)
                .foregroundColor(Color(.labelNormal))
        }
        .frame(width: 80, height: 116)
    }
}
