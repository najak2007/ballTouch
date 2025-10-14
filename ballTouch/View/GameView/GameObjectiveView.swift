//
//  GameObjectiveView.swift
//  ballTouch
//
//  Created by najak on 10/2/25.
//

import SwiftUI
import Foundation

struct GameObjectiveView: View {
    
    @State private var selectedScore: Int = 1
    @State private var selectedTime: Int = 1
    
    @Binding var savedScoreIndex: Int
    @Binding var savedTimeIndex: Int
    
    var selectHandler: ((GameObjective, Int) -> Void)
    
    var body: some View {
        List {
            ForEach(GameObjective.allCases) { objective in
                Button(action: {
                    self.selectHandler(objective, selectedScore)
                }, label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(objective.id)
                                .font(.custom("GmarketSansTTFMedium", size: 20))
                                .foregroundColor(Color("1F2020"))
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 0)
                            
                            if objective == .합산_점수 {
                                Text("합산 점수가 제일 높으면 승리합니다.")
                                    .font(.custom("GmarketSansTTFMedium", size: 14))
                                    .foregroundColor(Color("1F2020").opacity(0.6))
                                    .lineSpacing(4)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                            } else if objective == .점수_맞추기 {
                                Text("\((selectedScore + 1)*10)점만 더하기, 그외 점수는 빼기")
                                    .font(.custom("GmarketSansTTFMedium", size: 14))
                                    .foregroundColor(Color("1F2020").opacity(0.6))
                                    .lineSpacing(4)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                            } else if objective == .시간_설정 {
                                Text("\((selectedTime + 1)*10)초 동안 게임 진행")
                                    .font(.custom("GmarketSansTTFMedium", size: 14))
                                    .foregroundColor(Color("1F2020").opacity(0.6))
                                    .lineSpacing(4)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        
                        Spacer()
                        
                        if objective == .합산_점수 {
#if true
                            Spacer()
#else
                            Text("합산 점수가 제일 높으면 승리")
                                .font(.custom("GmarketSansTTFMedium", size: 14))
                                .foregroundColor(Color("1F2020"))
                                .lineSpacing(4)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                                .frame(width: 120)
#endif
                        } else if objective == .점수_맞추기 {
                            Picker("", selection: $selectedScore) {
                                ForEach(1..<11) { number in
                                    Text("\(number * 10)점")
                                        .font(.custom("GmarketSansTTFMedium", size: 14))
                                }
                            }
                            .frame(width: 120)
                            .pickerStyle(.menu)
                            .tint(Color("1F2020"))
                            .onAppear {
                                self.selectedScore = savedScoreIndex
                            }
                        } else if objective == .시간_설정 {
                            Picker("", selection: $selectedTime) {
                                ForEach(1..<11) { number in
                                    Text("\(number * 10)초")
                                        .font(.custom("GmarketSansTTFMedium", size: 14))
                                }
                            }
                            .frame(width: 120)
                            .pickerStyle(.menu)
                            .tint(Color("1F2020"))
                            .onAppear {
                                self.selectedTime = savedTimeIndex
                            }
                        }
                    }
                })
            }
        }
        .environment(\.defaultMinListRowHeight, 80)
        .scrollDisabled(true)
    }
}
