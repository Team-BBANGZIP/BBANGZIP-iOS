//
//  TimerView.swift
//  BBANGZIP
//
//  Created by 조성민 on 5/20/25.
//

import SwiftUI

struct TimerView: View {
    @ObservedObject var viewModel: TimerViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                
                Text("\(viewModel.breadCount)")
                    .bbangFont(.title3)
                    .bbangColor(.primaryNormal)
                    .monospacedDigit()
                    .opacity(viewModel.breadCount == 0 ? 0 : 1)
            }
            
            Spacer()
            
            Text(viewModel.announceMessage)
                .bbangFont(.title2)
                .bbangColor(.labelAlternative)
            
            Text(viewModel.leftTimeText)
                .bbangFont(.timer)
                .bbangColor(.primaryLight)
                .monospacedDigit()
            
            ToggleButton(isToggleOn: $viewModel.isTimerHour)
                .opacity(viewModel.state == .initial ? 1 : 0)
                .disabled(viewModel.state != .initial)
            
            Spacer()
            
            HStack(spacing: 16) {
                if viewModel.state != .initial {
                    refreshButton
                }
                timerControlButton
                if viewModel.state != .initial {
                    resetButton
                }
            }
            .padding(.bottom, 48)
        }
        .sheet(isPresented: $viewModel.isResetSheetOn) {
            resetSheet
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $viewModel.isRefreshSheetOn) {
            refreshSheet
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $viewModel.isCompleteSheetOn) {
            completeSheet
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
    
    var refreshButton: some View {
        Button {
            viewModel.refreshButtonTapped()
        } label: {
            Image(.icRefreshThick)
                .renderingMode(.template)
                .resizable()
                .frame(width: 26, height: 26)
                .foregroundStyle(Color.primaryNormal)
                .opacity(0.6)
        }
        .disabled(viewModel.state == .done)
        .frame(width: 48, height: 48)
        .clipShape(.circle)
        .overlay(
            Circle()
                .stroke(Color.secondaryStrong, lineWidth: 1)
        )
        .opacity(viewModel.state == .done ? 0.5 : 1)
    }
    
    var refreshSheet: some View {
        VStack(spacing: 0) {
            Text("정말 초기화 하시겠어요?")
                .bbangFont(.title1)
                .bbangColor(.primaryNormal)
                .padding(.top, 40)
                .padding(.bottom, 4)
            
            Text("지금까지 구운 빵이 완성되지 않아요")
                .bbangFont(.body1)
                .bbangColor(.labelAlternative)
                .padding(.bottom, 28)
            
            Image(.icPerson) // TODO: 이미지 빵으로 변경
                .resizable()
                .frame(width: .infinity)
                .padding(.horizontal, 4)
                .padding(.bottom, 42)
            HStack(spacing: 8) {
                Button("돌아가기") {
                    viewModel.isRefreshSheetOn = false
                }
                .buttonStyle(
                    BbangButtonStyle(
                        style: .secondary,
                        rightIcon: Image(.icRefreshThin)
                    )
                )
                
                Button("초기화 하기") {
                    viewModel.refreshTimer()
                    viewModel.isRefreshSheetOn = false
                }
                .buttonStyle(
                    BbangButtonStyle(
                        style: .primary,
                        rightIcon: Image(.icQuit)
                    )
                )
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }
    
    var timerControlButton: some View {
        Button {
            viewModel.timerControlButtonTapped()
        } label: {
            Image(viewModel.state == .running ? .icPause : .icStart)
                .renderingMode(.template)
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundStyle(viewModel.state == .running ? Color.primaryNormal : Color.secondaryNormal)
        }
        .frame(width: 80, height: 80)
        .clipShape(.circle)
        .background(
            Circle()
                .fill(viewModel.state == .running ? Color.secondaryStrong : Color.primaryStrong)
        )
    }
    
    var resetButton: some View {
        Button {
            viewModel.resetButtonTapped()
        } label: {
            Image(.icStop)
                .renderingMode(.template)
                .foregroundStyle(Color.primaryNormal)
                .opacity(0.6)
        }
        .frame(width: 48, height: 48)
        .clipShape(.circle)
        .overlay(
            Circle()
                .stroke(Color.secondaryStrong, lineWidth: 1)
        )
    }
    
    var resetSheet: some View  {
        VStack(spacing: 0) {
            Text("정말 종료 하시겠어요?")
                .bbangFont(.title1)
                .bbangColor(.primaryNormal)
                .padding(.top, 40)
                .padding(.bottom, 4)
            
            Text("\(1)분만 더 하면 빵 \(viewModel.isTimerHour ? "두" : "한") 개를 얻을 수 있어요") // TODO: N분 수정
                .bbangFont(.body1)
                .bbangColor(.labelAlternative)
                .padding(.bottom, 28)
            
            Image(.icPerson) // TODO: 이미지 빵으로 변경
                .resizable()
                .frame(width: .infinity)
                .padding(.horizontal, 4)
                .padding(.bottom, 42)
            HStack(spacing: 8) {
                Button("돌아가기") {
                    viewModel.isResetSheetOn = false
                }
                .buttonStyle(
                    BbangButtonStyle(
                        style: .secondary,
                        rightIcon: Image(.icRefreshThin)
                    )
                )
                
                Button("종료 하기") {
                    viewModel.resetTimer()
                    viewModel.isResetSheetOn = false
                }
                .buttonStyle(
                    BbangButtonStyle(
                        style: .primary,
                        rightIcon: Image(.icQuit)
                    )
                )
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }
    
    var completeSheet: some View {
        VStack(spacing: 0) {
            Text("역시 사장님은 제빵왕!")
                .bbangFont(.title1)
                .bbangColor(.primaryNormal)
                .padding(.top, 40)
                .padding(.bottom, 4)
            
            Text("빵 \(viewModel.isTimerHour ? "두" : "한") 개를 흭득했어요")
                .bbangFont(.body1)
                .bbangColor(.labelAlternative)
                .padding(.bottom, 28)
            
            Image(.icPerson) // TODO: 이미지 빵으로 변경
                .resizable()
                .frame(width: .infinity)
                .padding(.horizontal, 4)
                .padding(.bottom, 42)
                
            GeometryReader { geometry in
                let width = geometry.size.width
                HStack(spacing: 8) {
                    Button("\(viewModel.isTimerHour ? "60" : "30")분 더") {
                        viewModel.timerControlButtonTapped()
                        viewModel.isCompleteSheetOn = false
                    }
                    .buttonStyle(
                        BbangButtonStyle(
                            style: .secondary,
                            rightIcon: Image(.icPlusThick)
                        )
                    )
                    .frame(width: width * 130 / 370)
                    
                    Button("완료한 일 체크") {
                        // TODO: 완료한 일 체크 페이지로 이동
                    }
                    .buttonStyle(
                        BbangButtonStyle(
                            style: .primary,
                            rightIcon: Image(.icBook)
                        )
                    )
                }
            }
            .frame(height: 48)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }
}

#Preview {
    TimerView(
        viewModel: TimerViewModel(timerUseCase: TimerUseCaseImpl())
    )
}
