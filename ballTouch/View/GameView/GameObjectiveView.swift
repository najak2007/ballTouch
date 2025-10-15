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
    
    @Binding var selectedGameObjective: GameObjective
    @Binding var savedScoreIndex: Int
    @Binding var savedTimeIndex: Int
    
    var selectHandler: ((GameObjective, Int) -> Void)
    
    var body: some View {
        List {
                Section(header: GameListHeaderView(headerText: "Game 모드", showAlignments: .좌측정렬)) {
                    ForEach(GameObjective.allCases) { objective in
                        if objective == .합산_점수 || objective == .점수_맞추기 {
                            Button(action: {
                                self.selectedGameObjective = objective
                            }, label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 8) {
                                        if selectedGameObjective == objective {
                                            HStack(spacing: 5) {
                                                Image(systemName: "checkmark.circle")
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                    .foregroundColor(Color("1F2020"))
                                                
                                                Text(objective.id)
                                                    .font(.custom("GmarketSansTTFMedium", size: 20))
                                                    .foregroundColor(Color("1F2020"))
                                                    .multilineTextAlignment(.leading)
                                                    .padding(.leading, 0)
                                            }
                                        } else {
                                            Text(objective.id)
                                                .font(.custom("GmarketSansTTFMedium", size: 20))
                                                .foregroundColor(Color("1F2020"))
                                                .multilineTextAlignment(.leading)
                                                .padding(.leading, 0)
                                        }
                                        
                                        if objective == .합산_점수 {
                                            Text(objective == .합산_점수 ? "합산 점수가 제일 높으면 승리합니다." : "\((selectedScore + 1)*10)점만 더하기, 그외 점수는 빼기")
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
                                    }
                                }
                            })
                        }
                    }
                }
                Section(header: GameListHeaderView(headerText: "Game 시간", showAlignments: .좌측정렬)) {
                    Button(action: {
                    }, label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("시간 설정")
                                    .font(.custom("GmarketSansTTFMedium", size: 20))
                                    .foregroundColor(Color("1F2020"))
                                    .multilineTextAlignment(.leading)
                                    .padding(.leading, 0)
                                
                                Text("\((selectedTime + 1)*10)초 동안 게임 진행")
                                    .font(.custom("GmarketSansTTFMedium", size: 14))
                                    .foregroundColor(Color("1F2020").opacity(0.6))
                                    .lineSpacing(4)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                            }
                            
                            Spacer()
                            
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
                            .onChange(of: selectedTime) { oldValue, newValue in
                                if oldValue != newValue {
                                    self.savedTimeIndex = newValue
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
