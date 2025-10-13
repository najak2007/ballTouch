//
//  GameObjectiveView.swift
//  ballTouch
//
//  Created by najak on 10/2/25.
//

import SwiftUI
import Foundation

struct GameObjectiveView: View {
    var selectHandler: ((GameObjective, Int) -> Void)
    @State private var selectedScore: Int = 1
    
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
                                    .foregroundColor(Color("1F2020"))
                                    .lineSpacing(4)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                            } else if objective == .점수_맞추기 {
                                Text("50점만 합산, 그외 점수는 차감됩니다.")
                                    .font(.custom("GmarketSansTTFMedium", size: 14))
                                    .foregroundColor(Color("1F2020"))
                                    .lineSpacing(4)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                            } else if objective == .시간_설정 {
                                Text("게임 시간을 설정해 주세요")
                                    .font(.custom("GmarketSansTTFMedium", size: 14))
                                    .foregroundColor(Color("1F2020"))
                                    .lineSpacing(4)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                            }
                        }
 //                       .frame(width: 300)

                        Spacer()
                        
                        if objective == .합산_점수 {
                            Text("합산 점수가 제일 높으면 승리")
                                .font(.custom("GmarketSansTTFMedium", size: 14))
                                .foregroundColor(Color("1F2020"))
                                .lineSpacing(4)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                                .frame(width: 120)
                        } else if objective == .점수_맞추기 {
                            Text("50점만 합산, 그외 점수는 차감")
                                .font(.custom("GmarketSansTTFMedium", size: 14))
                                .foregroundColor(Color("1F2020"))
                                .lineSpacing(4)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                                .frame(width: 120)
                        } else if objective == .시간_설정 {
#if false
                            Menu("\(selectedScore * 30)초") {
                                ForEach(2..<5) { number in
                                    Button(action: {
                                        selectedScore = number
                                    }, label: {
                                        Text("60초")
                                            .font(.custom("GmarketSansTTFMedium", size: 14))
                                            .foregroundColor(Color("1F2020"))
                                    })
                                }
                            }
#else
                            Picker("", selection: $selectedScore) {
                                ForEach(1..<4) { number in
                                    Text("\(number * 30)초")
                                        .font(.custom("GmarketSansTTFMedium", size: 14))
                                }
                            }
                            .font(.custom("GmarketSansTTFMedium", size: 14))
                            .foregroundColor(Color("1F2020"))
                            .lineSpacing(4)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            .frame(width: 120)
                            .pickerStyle(.menu)
#endif
                        }
                    }
                })
            }
        }
        .environment(\.defaultMinListRowHeight, 80)
        .scrollDisabled(true)
    }
}
