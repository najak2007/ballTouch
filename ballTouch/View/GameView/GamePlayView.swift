//
//  GamePlayView.swift
//  ballTouch
//
//  Created by najak on 10/2/25.
//

import SwiftUI

struct GamePlayView: View {
    @State var balls: [Ball] = []
    @State var score: Int = 0
    let ballCount = 7

    var body: some View {
        ZStack {
#if __NOT_USE__
            Color(hex: "f8ede3")
#endif
            VStack {
                Text("CatchGoinMac")
                    .font(.custom("GmarketSansTTFBold", size: 24))
                    .foregroundColor(Color("1F2020"))
                Text("\(score)")
                    .font(.custom("GmarketSansTTFBold", size: 20))
                    .foregroundColor(Color("1F2020"))
                    .monospacedDigit()
                
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
                                            if balls[index].touched == false {
                                                score += balls[index].point
                                                balls[index].touched = true
                                                balls[index].isStopped = true
                                                balls[index].isAnimating = true
                                                balls[index].timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
                                                    balls[index].reproduceBall(geometry: geometry)
                                                    balls[index].isStopped = false
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
    
    func startTimer(geometry: GeometryProxy) {
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            for i in 0..<balls.count {
                balls[i].updatePosition(in: geometry)
            }
        }
    }
}
