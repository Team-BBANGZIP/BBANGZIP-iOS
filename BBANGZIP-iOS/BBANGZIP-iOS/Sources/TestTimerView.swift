//
//  TestTimerView.swift
//  BBANGZIP
//
//  Created by 김송희 on 5/26/25.
//

import SwiftUI

struct TestTimerView: View {
    @State private var isSheetPresented = false
    
    var body: some View {
        VStack {
            Button("바텀시트 열기") {
                isSheetPresented = true
            }
        }
        .sheet(isPresented: $isSheetPresented) {
            BreadSelectView()
                .presentationDetents([.height(576)])
                .presentationCornerRadius(48)
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    TestTimerView()
}
