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
        VStack {
            if viewModel.breadCount > 0 {
                BbangText("\(viewModel.breadCount)", font: .title3)
            }
            
            BbangText(viewModel.announceMessage, font: .title3)
            
            BbangText(viewModel.leftTimeText, font: .title2)
            
            HStack {
                if viewModel.state == .paused {
                    Button {
                        viewModel.refreshTimer()
                    } label: {
                        Image(.icRefreshThin)
                    }
                }
                
                Button {
                    viewModel.timerControlButtonTapped()
                } label: {
                    Image(viewModel.state == .running ? .icPause : .icStart)
                }
                
                if viewModel.state == .paused {
                    Button {
                        viewModel.resetTimer()
                    } label: {
                        Image(.icStop)
                    }
                }
            }
            
            if viewModel.state == .initial {
                ToggleButton(isToggleOn: $viewModel.isTimerHour)
            }
        }
    }
}

#Preview {
    TimerView(
        viewModel: TimerViewModel(timerUseCase: TimerUseCaseImpl())
    )
}
