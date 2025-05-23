//
//  CheckedOffView.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/23/25.
//

import SwiftUI

struct CheckedOffView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                    // TODO: 뒤로가기 액션 기능 구현 필요
                }) {
                    Image(.icChevronLeft)
                        .foregroundColor(Color(.labelAlternative))
                        .padding(.leading, 16)
                }

                Spacer()
            }
            .padding(.top, 15)
            
            Text("어떤 할 일을 완료하셨나요?")
                .bbangFont(.picker1)
                .foregroundColor(Color(.labelNomal))
                .padding(.leading, 20)
                .padding(.top, 34)
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

struct CheckedOffView_Previews: PreviewProvider {
    static var previews: some View {
        CheckedOffView()
    }
}
