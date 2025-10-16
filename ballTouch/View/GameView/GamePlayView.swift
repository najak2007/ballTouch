//
//  GamePlayView.swift
//  ballTouch
//
//  Created by najak on 10/2/25.
//

import SwiftUI

struct GamePlayView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var balls: [Ball] = []
    @State var score: Int = 0
    let ballCount = 7
    
    @Binding var selectedGameObjective: GameObjective
    @Binding var savedScoreIndex: Int
    @Binding var savedTimeIndex: Int
    
    @State private var startDate = Date()
    @State private var endDate: Date = Date().addingTimeInterval(30)
    @State private var pauseDate: Date = Date().addingTimeInterval(0)
    @State private var gamePlayTimer: Timer?
    @State private var gameState: GameState = .초기화
    @State private var currentGeometry: GeometryProxy? = nil
    @State private var playingTime: Int = 0

    var body: some View {
        ZStack {
#if __NOT_USE__
            Color(hex: "f8ede3")
#endif
            VStack {
                HStack {
                    Text(selectedGameObjective.id)
                        .font(.custom("GmarketSansTTFBold", size: 16))
                        .foregroundColor(Color("1F2020"))
                    
                    Spacer()
                    
                    Text("\(score)")
                        .font(.system(size: 18, weight: .semibold))
                        .tracking(4)
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
                            .tracking(4)
                            .monospacedDigit()
                            .italic()
                            .foregroundColor(Color("1F2020"))
//                            .onAppear {
//                                startDate = Date()
//                                endDate = startDate.addingTimeInterval(Double((savedTimeIndex + 1) * 10))
//                                DispatchQueue.main.asyncAfter(deadline: .now() + Double((savedTimeIndex + 1) * 10)) {
//                                    self.finishGame()
//                                }
//                            }
                    }
                }
                .frame(height: Config.NAVIGATION_HEIGHT)
                .padding(.horizontal, 20)

                
                GeometryReader { geometry in
                    ZStack {
                        ForEach(balls.indices, id: \.self) { index in
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
                                                score += balls[index].point
                                                balls[index].touched = true
                                                balls[index].isStopped = true
                                                balls[index].isAnimating = true
                                                balls[index].timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
                                                    balls[index].reproduceBall(geometry: geometry)
                                                    balls[index].isStopped = false
                                                    balls[index].isAnimating = false
                                                }
                                            }
                                        }
                                )
                                .animation(.spring(), value: balls[index].isAnimating)
                            }
                        }
                    }
                    .onAppear {
                        for _ in 0..<ballCount {
                            balls.append(Ball(in: geometry))
                        }
                        
                        startTimer(geometry: geometry)
                    }
                    .onDisappear {
                        balls.removeAll()
                    }
                }
            }
        }
    }
    
    func gameConfiguration() {
        startDate = Date()
        endDate = startDate.addingTimeInterval(Double((savedTimeIndex + 1) * 10))
        DispatchQueue.main.asyncAfter(deadline: .now() + Double((savedTimeIndex + 1) * 10)) {
            self.finishGame()
        }
    }
    
    func startTimer(geometry: GeometryProxy, isInit: Bool = true) {
        currentGeometry = geometry
        gamePlayTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            for i in 0..<balls.count {
                balls[i].updatePosition(in: geometry)
            }
        }
        gameState = .게임중
        
        if isInit == true {
            if score > 0 {
                score = 0
            }
            gameConfiguration()
        }
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
            startDate = Date()
            pauseDate = startDate.addingTimeInterval(Double(finishTime - playingTime))
        }
        gamePlayTimer = nil
        gameState = .일시정지
    }
    
    func resumeTimer() {
        if let geometry = currentGeometry {
            let playingTime = getPlayingTime(startDate)
            let finishTime = getPlayingTime(startDate, endDate)
            startDate = Date()
            endDate = startDate.addingTimeInterval(Double(finishTime - playingTime))

            startTimer(geometry: geometry, isInit: false)
        }
    }
    
    func finishGame() {
//        stopTimer(isFinish: true)
//        balls.removeAll()
    }
    
    func reGameStart() {
        if let geometry = currentGeometry {
            for _ in 0..<ballCount {
                balls.append(Ball(in: geometry))
            }
            startTimer(geometry: geometry)
        }
    }
    
    
    func getPlayingTime(_ fromDate: Date, _ toDate: Date = Date()) -> Int {
        let timeGap = Calendar.current.dateComponents([.second], from: fromDate, to: toDate)
        return timeGap.second ?? 0
    }
}
