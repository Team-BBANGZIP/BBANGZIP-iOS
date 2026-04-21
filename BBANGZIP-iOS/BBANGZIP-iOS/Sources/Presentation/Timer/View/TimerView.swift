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
                breadCountChip
            }
            .padding(.top, 17)
            
            Spacer()
            
            VStack(spacing: 30) {
                announceText
                leftTimeView
                timeToggleButton
            }
            
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
            .padding(.bottom, 126)
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .toolbar(viewModel.state == .running || viewModel.state == .paused ? .hidden : .visible, for: .tabBar)
        .sheet(isPresented: $viewModel.isResetSheetOn) {
            resetSheet
        }
        .sheet(isPresented: $viewModel.isRefreshSheetOn) {
            refreshSheet
        }
        .sheet(isPresented: $viewModel.isCompleteSheetOn) {
            completeSheet
        }
        .sheet(isPresented: $viewModel.isBreadSelectSheetOn) {
            breadSelectSheet
        }
    }
    
    var breadCountChip: some View {
        HStack(spacing: 1) {
            Image(.icBread)
                .renderingMode(.template)
                .foregroundStyle(Color(.primaryLight))
                .padding(.leading, 5)
            
            Text("\(viewModel.breadCount)")
                .bbangFont(.title3)
                .bbangColor(.primaryNormal)
                .padding(.trailing, 10)
        }
        .overlay(
            Capsule()
                .stroke(Color(.primaryLight), lineWidth: 1)
        )
        .padding(.trailing, 20)
    }
    
    var announceText: some View {
        let opacity: Double = viewModel.state == .running ? 0 : 1
        
        return Text(viewModel.announceText)
            .bbangFont(.title2)
            .bbangColor(.labelAlternative)
            .opacity(opacity)
    }
    
    var leftTimeView: some View {
        let lineWidth: CGFloat = 311 * 0.035
        let textColor: BbangzipColor = viewModel.state == .running ? .primaryNormal : viewModel.state == .done ? .primaryStrong : .primaryLight
        
        return ZStack {
            Circle()
                .stroke(lineWidth: 10)
                .foregroundStyle(Color(.staticwhite))
                .padding(5)
                .zIndex(1)
            
            Circle()
                .stroke(lineWidth: lineWidth)
                .foregroundStyle(
                    Color(.secondaryNormal)
                        .shadow(.inner(color: Color(.timerShadow), radius: 2, x: 0, y: 1))
                )
                .zIndex(1)
            
            Circle()
                .trim(from: 0, to: viewModel.progressPercentage)
                .stroke(
                    Color(.primaryLight)
                        .shadow(.inner(color: Color(.timerProgressShadow), radius: 4, x: 0, y: 2)),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round)
                )
                .rotationEffect(.degrees(-90))
                .zIndex(1)
            
            VStack(spacing: 0) {
                Spacer().frame(height: 100)
                
                Text(viewModel.leftTimeText)
                    .bbangFont(.timer)
                    .bbangColor(textColor)
                
                ArrowView()
                    .padding(.bottom, 8)
                    .opacity(viewModel.state == .initial ? 1 : 0)
                
                Button(action: {
                    viewModel.breadImageTapped()
                }) {
                    breadImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 115, height: 84)
                        .animation(.easeInOut(duration: 0.5), value: viewModel.currentBreadLevel)
                }
                .disabled(viewModel.state != .initial)
            }
            .zIndex(0)
        }
        .frame(width: 311, height: 311)
        .padding(.horizontal, 38)
        .padding(.vertical, 6)
    }
    
    private var breadImage: Image {
        let level = viewModel.currentBreadLevel
        let isPaused = viewModel.state == .paused
        
        switch level {
        case 1:
            return Image(.itemSaltBread)
        case 2:
            return isPaused ? Image(.level1) : Image(.breadLevel1)
        case 3:
            return isPaused ? Image(.level2) : Image(.breadLevel2)
        case 4:
            return isPaused ? Image(.level3) : Image(.breadLevel3)
        case 5:
            return isPaused ? Image(.level4) : Image(.breadLevel4)
        default:
            return Image(.itemSaltBread)
        }
    }
    
    var timeToggleButton: some View {
        let opacity: Double = viewModel.state == .initial ? 1 : 0
        let disabled = viewModel.state != .initial
        
        return ToggleButton(isToggleOn: $viewModel.isHour)
            .opacity(opacity)
            .disabled(disabled)
            .padding(.bottom, 7)
    }
    
    var refreshButton: some View {
        let opacity = viewModel.state == .done ? 0.5 : 1
        let disabled = viewModel.state == .done
        
        return Button {
            viewModel.refreshButtonTapped()
        } label: {
            Image(.icRefreshThick)
                .renderingMode(.template)
                .resizable()
                .frame(width: 26, height: 26)
                .foregroundStyle(Color(.primaryNormal))
                .opacity(0.6)
        }
        .disabled(disabled)
        .frame(width: 48, height: 48)
        .clipShape(.circle)
        .overlay(
            Circle().stroke(Color(.secondaryStrong), lineWidth: 1)
        )
        .opacity(opacity)
    }
    
    var refreshSheet: some View {
        VStack(spacing: 0) {
            Text("정말 초기화하시겠어요?")
                .bbangFont(.title1)
                .bbangColor(.primaryNormal)
                .padding(.top, 40)
                .padding(.bottom, 4)
            
            Text("지금까지 구운 빵이 완성되지 않아요")
                .bbangFont(.body1)
                .bbangColor(.labelAlternative)
                .padding(.bottom, 28)
            
            Image(.refresh)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 4)
                .padding(.bottom, 42)
            
            HStack(spacing: 8) {
                Button("돌아가기") {
                    viewModel.refreshSheetBackButtonTapped()
                }
                .buttonStyle(BbangButtonStyle(style: .primary, rightIcon: Image(.icBackward)))
                
                Button("초기화 하기") {
                    viewModel.refreshSheetRefreshButtonTapped()
                }
                .buttonStyle(BbangButtonStyle(style: .secondary, rightIcon: Image(.icQuit)))
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
        .modifier(CornerRadiusModifier())
    }
    
    var timerControlButton: some View {
        let image: ImageResource = viewModel.state == .running ? .icPause : .icStart
        let imageColor: Color = viewModel.state == .running ? Color(.primaryNormal) : Color(.secondaryNormal)
        let backgroundColor: Color = viewModel.state == .running ? Color(.secondaryStrong) : Color(.primaryStrong)
        
        return Button {
            viewModel.timerControlButtonTapped()
        } label: {
            Image(image)
                .renderingMode(.template)
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundStyle(imageColor)
        }
        .frame(width: 80, height: 80)
        .background(
            Circle()
                .fill(
                    backgroundColor
                        .shadow(.inner(color: Color(.timerInnerShadow), radius: 1, x: 0, y: 1))
                        .shadow(.inner(color: Color(.timerInnerShadow2), radius: 10, x: 0, y: 2))
                )
        )
        .shadow(
            color: viewModel.state == .running ? Color.clear : Color(.timerDropShadow),
            radius: viewModel.state == .running ? 0 : 5,
            x: 0,
            y: viewModel.state == .running ? 0 : 2
        )
    }
    
    var resetButton: some View {
        Button {
            viewModel.resetButtonTapped()
        } label: {
            Image(.icStop)
                .renderingMode(.template)
                .foregroundStyle(Color(.primaryNormal))
                .opacity(0.6)
        }
        .frame(width: 48, height: 48)
        .clipShape(.circle)
        .overlay(
            Circle().stroke(Color(.secondaryStrong), lineWidth: 1)
        )
    }
    
    var resetSheet: some View {
        return VStack(spacing: 0) {
            Text("정말 종료 하시겠어요?")
                .bbangFont(.title1)
                .bbangColor(.primaryNormal)
                .padding(.top, 40)
                .padding(.bottom, 4)
            
            Text("\(viewModel.resetSheetLeftTimeText)만 더 하면 빵 \(viewModel.resetSheetBreadCount) 개를 얻을 수 있어요")
                .bbangFont(.body1)
                .bbangColor(.labelAlternative)
                .padding(.bottom, 28)
            
            Image(viewModel.resetSheetImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 42)
            
            HStack(spacing: 8) {
                Button("돌아가기") {
                    viewModel.resetSheetBackButtonTapped()
                }
                .buttonStyle(BbangButtonStyle(style: .primary, rightIcon: Image(.icBackward)))
                
                Button("종료하기") {
                    viewModel.resetSheetResetButtonTapped()
                }
                .buttonStyle(BbangButtonStyle(style: .secondary, rightIcon: Image(.icQuit)))
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
        .modifier(CornerRadiusModifier())
    }
    
    var completeSheet: some View {
        let minute = viewModel.isHour ? "60" : "30"
        
        return VStack(spacing: 0) {
            Text("역시 사장님은 제빵왕!")
                .bbangFont(.title1)
                .bbangColor(.primaryNormal)
                .padding(.top, 40)
                .padding(.bottom, 4)
            
            Text("빵 \(viewModel.completeSheetBreadCount) 개를 흭득했어요")
                .bbangFont(.body1)
                .bbangColor(.labelAlternative)
                .padding(.bottom, 28)
            
            LottieView(fileName: viewModel.completeSheetLottieFileName)
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fit)
                .padding(.horizontal, 4)
                .padding(.bottom, 42)
            
            GeometryReader { geometry in
                let width = geometry.size.width
                HStack(spacing: 8) {
                    Button("\(minute)분 더") {
                        viewModel.completeSheetMoreButtonTapped()
                    }
                    .buttonStyle(BbangButtonStyle(style: .secondary, rightIcon: Image(.icPlusThick)))
                    .frame(width: width * 130 / 370)
                    
                    Button("완료한 일 체크") {
                        viewModel.completeSheetCompleteButtonTapped()
                    }
                    .buttonStyle(BbangButtonStyle(style: .primary, rightIcon: Image(.icBook)))
                }
            }
            .frame(height: 48)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
        .modifier(CornerRadiusModifier())
    }
    
    var breadSelectSheet: some View {
        BreadSelectView(
            viewModel: BreadSelectViewModel(
                breadList: BreadList(totalCount: 0, breadList: []),
                getBreadsUseCase: GetBreadsUseCase(repository: GetBreadsRepository())
            )
        )
        .presentationDetents([.height(604)])
        .presentationDragIndicator(.visible)
        .modifier(CornerRadiusModifier())
    }
}

struct CornerRadiusModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.4, *) {
            content.presentationCornerRadius(48)
        } else {
            content.background(
                RoundedRectangle(cornerRadius: 48, style: .continuous)
                    .fill(Color(.systemBackground))
            )
        }
    }
}

struct ArrowView: View {
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        Image(.icTriangleDown)
            .renderingMode(.template)
            .foregroundStyle(Color(.primaryNormal))
            .offset(y: animationOffset)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    animationOffset = 8
                }
            }
    }
}

//#Preview {
//    TimerView(
//        viewModel: TimerViewModel(
//            timerUseCase: TimerUseCaseImpl(),
//            breadCountUseCase: BreadCountUseCaseImpl(
//                repository: BreadCountRepositoryImpl()
//            )
//        )
//    )
//}
