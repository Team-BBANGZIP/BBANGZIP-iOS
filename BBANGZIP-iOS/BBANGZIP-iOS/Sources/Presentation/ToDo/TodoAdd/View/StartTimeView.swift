//
//  StartTimeView.swift
//  BBANGZIP
//
//  Created by 김송희 on 8/20/25.
//

import SwiftUI

struct StartTimeView: View {
    @ObservedObject var viewModel: StartTimeViewModel
    @Binding var isSheetPresented: Bool
    let onSelect: (Date?) -> Void

    var body: some View {
        ZStack {
            Text("시작 시간 설정")
                .bbangFont(.title3)
                .foregroundStyle(Color(.labelAlternative))

            HStack {
                Button(action: {
                    onSelect(nil)
                    isSheetPresented = false
                }) {
                    HStack(spacing: 4) {
                        Image(.icRefreshThin)
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Color(.todored2))

                        Text("초기화")
                            .bbangFont(.label2)
                            .foregroundStyle(Color(.todored2))
                    }
                }

                Spacer()
            }
        }
        .padding(.top, 25)
        .padding(.horizontal, 24)

        timePicker
            .padding(.horizontal, 20)
            .padding(.top, 32)

        buttons
            .padding(.horizontal, 20)
            .padding(.top, 48)
    }

    var timePicker: some View {
        DatePicker(
            "",
            selection: $viewModel.tempTime,
            displayedComponents: .hourAndMinute
        )
        .datePickerStyle(.wheel)
        .labelsHidden()
        .scaleEffect(0.9)
    }

    var buttons: some View {
        HStack(spacing: 15) {
            Button("취소") {
                isSheetPresented = false
            }
            .buttonStyle(
                BbangButtonStyle(
                    style: .secondary,
                    rightIcon: Image(.icQuit)
                )
            )

            Button("설정") {
                onSelect(viewModel.tempTime)
                isSheetPresented = false
            }
            .buttonStyle(
                BbangButtonStyle(
                    style: .primary,
                    rightIcon: Image(.icCheck)
                )
            )
        }
    }
}
