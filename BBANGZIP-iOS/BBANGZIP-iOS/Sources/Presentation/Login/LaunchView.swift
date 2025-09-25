//
//  LaunchView.swift
//  BBANGZIP
//
//  Created by 송여경 on 9/24/25.
//

import SwiftUI

struct LaunchView: View {
    var body: some View {
        ZStack {
            Color(.appleLabel)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                VStack (spacing: 294) {
                    Image(.serviceLogo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 252, height: 140)
                    
                    Image(.teamInfo)
                    
                }
            }
            .padding(.bottom, 56)
            .ignoresSafeArea()
        }
    }
}

#Preview {
    LaunchView()
}
