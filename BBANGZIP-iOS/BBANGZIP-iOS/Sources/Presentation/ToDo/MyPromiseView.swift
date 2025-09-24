//
//  MyPromiseView.swift
//  BBANGZIP
//
//  Created by 김송희 on 9/1/25.
//

import SwiftUI

struct MyPromiseView: View {
    @State private var promiseText: String = ""
    
    init(text: String = "") {
        _promiseText = State(initialValue: text)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("나만의 다짐 작성")
                .bbangFont(.title3)
                .foregroundStyle(Color(.labelAlternative))
                .padding(.top, 50)
            
            PromiseInputField(text: $promiseText)
                .padding(.horizontal, 20)
                .padding(.top, 31)
                .padding(.bottom, 28)
        }
    }
}

#Preview {
    MyPromiseView(text: "")
}
