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
    @Binding var gamePlayMode: GamePlayMode
    @Binding var savedScoreIndex: Int
    @Binding var savedTimeIndex: Int
    
    var selectHandler: ((GameObjective, Int) -> Void)
    
    var body: some View {
        List {
            Section(header: GameListHeaderView(headerText: "Game Play 모드", showAlignments: .좌측정렬)) {
                ForEach(GamePlayMode.allCases) { playMode in
                    if gamePlayMode == playMode {
                        Button(action: {
                            
                        }, label: {
                            HStack(spacing: 5) {
                                Image(systemName: "checkmark.circle")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color("1F2020"))
                                
                                Text(playMode.id)
                                    .font(.custom("GmarketSansTTFMedium", size: 20))
                                    .foregroundColor(Color("1F2020"))
                                    .multilineTextAlignment(.leading)
                                    .padding(.leading, 0)
                            }
                        })
                    } else {
                        Button(action: {
                            self.gamePlayMode = playMode
                        }, label: {
                            Text(playMode.id)
                                .font(.custom("GmarketSansTTFMedium", size: 20))
                                .foregroundColor(Color("1F2020"))
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 0)
                        })
                    }
                }
            }
            
            Section(header: GameListHeaderView(headerText: "Game 점수", showAlignments: .좌측정렬)) {
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
                                        Text("합산 점수가 제일 높으면 승리합니다.")
                                            .font(.custom("GmarketSansTTFMedium", size: 14))
                                            .foregroundColor(Color("1F2020").opacity(0.6))
                                            .lineSpacing(4)
                                            .lineLimit(2)
                                            .multilineTextAlignment(.leading)
                                    } else {
                                        Text(setSubAttributedString(selectedScore))
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
                                    .onChange(of: selectedScore) { oldValue, newValue in
                                        if oldValue != newValue {
                                            savedScoreIndex = newValue
                                        }
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
                            ForEach(1..<7) { number in
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
    
    func setSubAttributedString(_ selectedScore: Int) -> AttributedString {
        var sttributedString = AttributedString("\((selectedScore + 1)*10)점만 +1 그외 점수는 -1")
            
        if let fullRange = sttributedString.range(of: "\((selectedScore + 1)*10)점만 +1 그외 점수는 -1") {
            sttributedString[fullRange].foregroundColor = Color("1F2020").opacity(0.6)
            sttributedString[fullRange].font = .custom("GmarketSansTTFMedium", size: 14)
        }
        
        if let plusRange = sttributedString.range(of: "+1") {
            sttributedString[plusRange].foregroundColor = .red
            sttributedString[plusRange].font = .custom("GmarketSansTTFBold", size: 15)
        }
        
        if let minusRange = sttributedString.range(of: "-1") {
            sttributedString[minusRange].foregroundColor = .blue
            sttributedString[minusRange].font = .custom("GmarketSansTTFBold", size: 15)
        }
        
        return sttributedString
    }
}
