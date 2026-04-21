//
//  BreadSelectView.swift
//  BBANGZIP
//
//  Created by 김송희 on 5/26/25.
//

import SwiftUI

struct BreadSelectView: View {
    @StateObject var viewModel: BreadSelectViewModel
    @State private var selectedBreadId: Int?
    
    private var lockedBreadItem: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topLeading) {
                Image(.itemLocked)
                    .resizable()
                    .scaledToFit()
                    .padding(.all, 24)
                    .padding(.vertical, 4)
            }
            
            Spacer()
            
            Text("???")
                .bbangFont(.body2)
                .foregroundColor(Color(.labelNormal))
        }
        .frame(width: 80, height: 116)
    }
    
    var body: some View {
        Spacer().frame(height: 10)
        
        VStack(spacing: 0) {
            Text("어떤 빵을 구울까요?")
                .bbangFont(.title1)
                .foregroundColor(Color(.primaryNormal))
            
            Text("오늘까지 총 \(viewModel.breadList.totalCount)개의 빵을 모았어요!")
                .bbangFont(.subtitle1)
                .foregroundColor(Color(.labelAlternative))
                .padding(.horizontal, 16)
                .padding(.vertical, 4)
                .background(Color(.backgroundAlternative))
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .padding(.top, 16)
                .padding(.bottom, 24)
            
            LazyVGrid(
                columns: Array(
                    repeating: GridItem(.flexible(), spacing: 0),
                    count: 3
                ),
                spacing: 32
            ) {
                ForEach(viewModel.breadList.breadList, id: \.breadId) { bread in
                    BreadItem(
                        breadId: bread.breadId,
                        breadName: bread.breadName,
                        isUnlocked: bread.isUnlocked,
                        requiredCount: bread.requiredCount,
                        imageUrl: bread.imageUrl,
                        isSelected: selectedBreadId == bread.breadId
                    )
                    .onTapGesture {
                        if bread.isUnlocked {
                            selectedBreadId = bread.breadId
                        }
                    }
                }
                
                ForEach(viewModel.breadList.breadList.count..<9, id: \.self) { index in
                    lockedBreadItem
                        .id("locked_\(index)")
                }
            }
            .padding(.horizontal, 31)
        }
    }
}
