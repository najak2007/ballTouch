//
//  GamePlayView.swift
//  ballTouch
//
//  Created by najak on 10/2/25.
//

import SwiftUI
import Combine

struct GamePlayView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var balls: [Ball] = []
    @State var score: Int = 0
    @State var ballCount = 7
    
    @State var gameGroupID: String = ""
    @Binding var selectedGameObjective: GameObjective
    @Binding var gamePlayMode: GamePlayMode
    @Binding var savedScoreIndex: Int
    @Binding var savedTimeIndex: Int
    
    @State private var startDate = Date()
    @State private var endDate: Date = Date().addingTimeInterval(30)
    @State private var pauseDate: Date = Date().addingTimeInterval(0)
    @State private var gamePlayTimer: Timer?
    @State private var gameState: GameState = .초기화
    @State private var currentGeometry: GeometryProxy? = nil
    @State private var playingTime: Int = 0
    @State private var gameCountTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var isGameResultShow: Bool = false
    @State private var isGamePointListShow: Bool = false
 
    @ObservedObject var gameViewModel = GameViewModel()
    
    @State private var scrollPosition: Int = 0

    var body: some View {
        ZStack {
#if __NOT_USE__
            Color(hex: "f8ede3")
#endif
            VStack {
                HStack {
                    HStack(spacing: 5) {
                        Text(selectedGameObjective.id)
                            .font(.custom("GmarketSansTTFBold", size: 16))
                            .foregroundColor(Color("1F2020"))
                        
                        
                        if selectedGameObjective == .점수_맞추기 {
                            Text(" 🎯\((savedScoreIndex + 1) * 10)점")
                                .font(.custom("GmarketSansTTFBold", size: 18))
                                .foregroundColor(Color("1F2020"))
                        }
                    }
                    Spacer()
                    
                    Text("\(score)")
                        .font(.system(size: 18, weight: .semibold))
                        .monospacedDigit()
                        .italic()
                        .foregroundColor(Color("1F2020"))

                    Spacer()
                    
                    HStack(spacing: 10) {
                        Button(action: {
                            if gameState == .게임중 {
                                self.pauseTimer()
                            } else if gameState == .일시정지 {
                                self.resumeTimer()
                            } else if gameState == .게임완료 {
                                self.reGameStart()
                            }
                        }, label: {
                            Image(systemName: gameState == .게임중 ? "pause.circle" : "play.circle")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(Color("1F2020"))
                        })
                        
                        if gameState == .일시정지 {
                            Button(action: {
                                dismiss()
                            }, label: {
                                Image(systemName: "stop.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(Color("1F2020"))
                            })
                        }
                        
                        
                        Text(
                            timerInterval: startDate...endDate,
                            pauseTime: pauseDate,
                            countsDown: true
                            
                        )
                            .font(.system(size: 18, weight: .semibold))
                            .monospacedDigit()
                            .italic()
                            .foregroundColor(Color("1F2020"))
                    }
                }
                .frame(height: Config.NAVIGATION_HEIGHT)
                .padding(.horizontal, 20)
                .padding(.top, 50)

                
                GeometryReader { geometry in
                    ZStack {
                        ForEach(balls.indices, id: \.self) { index in
                            if gameState == .게임중 {
                                if balls[index].isInside(geometry: geometry) {
                                    ZStack {
                                        Circle()
                                            .fill(balls[index].color)
                                            .frame(width: balls[index].size, height: balls[index].size)
                                            .scaleEffect(balls[index].isAnimating ? 0.2 : 1.0)
                                        balls[index].label      // 라벨 추가
                                    }
                                    .position(balls[index].position)
                                    .gesture(
                                        TapGesture(count: 1)
                                            .onEnded {
                                                if balls[index].touched == false, gameState == .게임중 {
                                                    if selectedGameObjective == .점수_맞추기 {
                                                        if ((savedScoreIndex + 1) * 10) == balls[index].point {
                                                            score += 1
                                                        } else {
                                                            score -= 1
                                                        }
                                                    } else {
                                                        score += balls[index].point
                                                    }
#if __NOT_USE__
                                                    balls[index].touched = true
                                                    balls[index].isStopped = true
                                                    balls[index].isAnimating = true
                                                    balls[index].timer = Timer.scheduledTimer(withTimeInterval: 0.0, repeats: false) { _ in
                                                        balls[index].reproduceBall(geometry: geometry)
                                                        balls[index].isStopped = false
                                                        balls[index].isAnimating = false
                                                    }
#else
                                                    if gamePlayMode == .빗방울 {
                                                        balls[index].reproduceBall(geometry: geometry)
                                                    } else {
                                                        for i in 0..<ballCount {
                                                            balls[i].setBallZeroSize()
                                                        }
                                                    }
                                                    balls[index].isStopped = false
                                                    balls[index].isAnimating = false
#endif
                                                }
                                            }
                                    )
                                    .animation(.spring(), value: balls[index].isAnimating)
                                }
                            }
                        }
                    }
                    .onAppear {
                        ballSetting(geometry: geometry)
                        startTimer(geometry: geometry, playingTime: (savedTimeIndex + 1) * 10)
                    }
                    .onDisappear {
                        finishGame(true)
                    }
                }
            }
        }
        .onReceive(gameCountTimer) { _ in
            if gameState == .게임중 {
                if getPlayingTime(Date(), endDate) < 0 {
                    self.finishGame()
                    gameCountTimer.upstream.connect().cancel()
                    self.gameResultSave()
                }
            }
        }
        .overlay {
            ZStack(alignment: .center) {
                Color.black.opacity(0.6).opacity(isGameResultShow ? 1: 0)
                    .onTapGesture {
#if __NOT_USE__
                        self.isGameResultShow.toggle()
#endif
                    }
                
                if self.isGameResultShow == true {
                    VStack {
                        Spacer()
                        
                        HStack(spacing: 80) {
                            if score == 0 {
                                Button(action: {
                                    self.isGameResultShow.toggle()
                                    self.reGameStart()
                                }, label: {
                                    Image(systemName: "repeat.circle.fill")
                                        .resizable()
                                        .frame(width: Config.GAME_START_BUTTON_SIZE, height: Config.GAME_START_BUTTON_SIZE)
                                        .foregroundColor(.white)
                                })
                            } else {
                                Button(action: {
                                    self.isGamePointListShow.toggle()
                                }, label: {
                                    Image(systemName: "list.number")
                                        .resizable()
                                        .frame(width: Config.GAME_START_BUTTON_SIZE, height: Config.GAME_START_BUTTON_SIZE)
                                        .foregroundColor(.white)
                                })
                                
                                Button(action: {
                                    self.isGameResultShow.toggle()
                                    self.reGameStart()
                                }, label: {
                                    Image(systemName: "repeat.circle.fill")
                                        .resizable()
                                        .frame(width: Config.GAME_START_BUTTON_SIZE, height: Config.GAME_START_BUTTON_SIZE)
                                        .foregroundColor(.white)
                                })
                            }
                        }
                        
                        Spacer()
                        
                        RoundedButton(title: "나가기", action: {
                            dismiss()
                        })
                        .padding(.bottom, 50)
                    }
                }
            }
            .padding(.top, 50)
        }
        .fullScreenCover(isPresented: $isGamePointListShow, onDismiss: {

        }) {
            GameResultListView(selectedGameObjective: $selectedGameObjective, gamePlayMode: $gamePlayMode, score: $score, savedScoreIndex: $savedScoreIndex, savedTimeIndex: $savedTimeIndex, scrollPosition: $scrollPosition)
        }
        .onAppear {
            self.ballCount = gamePlayMode == .빗방울 ? Config.GAME_PLAY_MODE_RAIN_DROP_COUNT : Config.GAME_PLAY_MODE_MOLE_COUNT
            
        }
        .ignoresSafeArea()
    }
    
    func gameResultSave() {
        if score > 0 {
            let gameResultData = GameResultData(
                            date: Date(),
                            gameGroupID: gameGroupID,
                            score: score,
                            gamePlayMode: gamePlayMode,
                            gamePlaySecond: ((savedTimeIndex + 1) * 10),
                            playName: "")
            self.scrollPosition = gameViewModel.gameResultAdd(resultData: gameResultData)
        }
    }
    
    func gameConfiguration(_ isInit: Bool = true, _ playingTime: Int) {
#if true
        startDate = Date()
        endDate = startDate.addingTimeInterval(Double(playingTime))
        pauseDate = startDate.addingTimeInterval(0)
#else
        startDate = Date()
        endDate = startDate.addingTimeInterval(Double((savedTimeIndex + 1) * 10))
        DispatchQueue.main.asyncAfter(deadline: .now() + Double((savedTimeIndex + 1) * 10)) {
            if self.gameState == .게임중 {
                self.finishGame()
            }
        }
#endif
    }
    
    func startTimer(geometry: GeometryProxy, isInit: Bool = true, playingTime: Int) {
        currentGeometry = geometry
        gamePlayTimer = Timer.scheduledTimer(withTimeInterval: gamePlayMode == .빗방울 ? 0.05 : CGFloat.random(in: 0.8...1.3), repeats: true) { _ in
            for i in 0..<ballCount {
                balls[i].updatePosition(in: geometry, ballIndex: i)
            }
        }
        gameState = .게임중
        
        if isInit == true {
            if score > 0 {
                score = 0
            }
        }
        gameConfiguration(isInit, playingTime)
        gameCountTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    func stopTimer(isFinish: Bool = false) {
        gamePlayTimer?.invalidate()
        gamePlayTimer = nil
        
        gameState = isFinish == true ? .게임완료 : .초기화
    }
    
    func pauseTimer() {
        gamePlayTimer?.invalidate()
        if let _ = gamePlayTimer {
            playingTime = getPlayingTime(startDate)
            let finishTime = getPlayingTime(startDate, endDate)
            pauseDate = startDate.addingTimeInterval(Double(finishTime - playingTime))
        }
        gamePlayTimer = nil
        gameState = .일시정지
        gameCountTimer.upstream.connect().cancel()
    }
    
    func resumeTimer() {
        if let geometry = currentGeometry {
            let finishTime = getPlayingTime(startDate, endDate)
            startDate = Date()
            endDate = startDate.addingTimeInterval(Double(finishTime - playingTime))
            startTimer(geometry: geometry, isInit: false, playingTime: (finishTime - playingTime))
        }
    }
    
    func finishGame(_ isDisappear: Bool = false) {
        stopTimer(isFinish: true)
        
        balls.removeAll()
        
        if isDisappear == false {
            DispatchQueue.main.asyncAfter(deadline: .now() + Config.GAME_RESULT_VIEW_FINISH_DELAY) {
                self.isGameResultShow.toggle()
            }
        }
    }
    
    func reGameStart() {
        if let geometry = currentGeometry {
            ballSetting(geometry: geometry)
            startTimer(geometry: geometry, playingTime: (savedTimeIndex + 1) * 10)
        }
    }
    
    
    func getPlayingTime(_ fromDate: Date, _ toDate: Date = Date()) -> Int {
        let timeGap = Calendar.current.dateComponents([.second], from: fromDate, to: toDate)
        return timeGap.second ?? 0
    }
    
    func ballSetting(geometry: GeometryProxy) {
        for _ in 0..<ballCount {
            balls.append(Ball(in: geometry, playMode: gamePlayMode))
        }
    }
}
