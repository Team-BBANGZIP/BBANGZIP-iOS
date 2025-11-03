//
//  BreadSelectView.swift
//  BBANGZIP
//
//  Created by 김송희 on 5/26/25.
//

import SwiftUI

struct BreadSelectView: View {
    @StateObject var viewModel: BreadSelectViewModel
    
    let breadList: [BreadItemModel] = [
        .init(breadName: "소금빵", isUnlocked: true, isSelected: true),
        .init(breadName: "???", isUnlocked: false, isSelected: false),
        .init(breadName: "???", isUnlocked: false, isSelected: false),
        .init(breadName: "???", isUnlocked: false, isSelected: false),
        .init(breadName: "???", isUnlocked: false, isSelected: false),
        .init(breadName: "???", isUnlocked: false, isSelected: false),
        .init(breadName: "???", isUnlocked: false, isSelected: false),
        .init(breadName: "???", isUnlocked: false, isSelected: false),
        .init(breadName: "???", isUnlocked: false, isSelected: false),
    ]
    
    var body: some View {
        Spacer().frame(height: 10)
        
        VStack(spacing: 0) {
            Text("어떤 빵을 구울까요?")
                .bbangFont(.title1)
                .foregroundColor(Color(.primaryNormal))
            
            // TODO: 서버에서 총 빵의 개수 받아오도록 API 연결
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
                        imageUrl: bread.imageUrl
                    )
                }
            }
            .padding(.horizontal, 31)
        }
    }
}

//#Preview {
//    TestTimerView()
//}
