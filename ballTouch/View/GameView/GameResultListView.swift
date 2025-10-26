//
//  GameResultListView.swift
//  ballTouch
//
//  Created by najak on 10/22/25.
//

import SwiftUI
import Foundation

struct GameResultListView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var selectedGameObjective: GameObjective
    @Binding var gamePlayMode: GamePlayMode
    @Binding var score: Int
    @Binding var savedScoreIndex: Int
    @Binding var savedTimeIndex: Int
    
    @State private var pointTableIndex: Int = 0
    
    @ObservedObject var gameViewModel = GameViewModel()
    @State private var gameResultDatas: [GameResultData] = []
    
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                Form {
                    Section {
#if __NOT_USE__
                        if self.selectedGameObjective == .합산_점수 {
                            Picker("", selection: $pointTableIndex) {
                                if self.selectedGameObjective == .합산_점수 {
                                    ForEach(1..<7) { tableValue in
                                        Text("\(tableValue) 초")
                                    }
                                }
                            }
                            .pickerStyle(.segmented)
                        } else {
                            Picker("", selection: $pointTableIndex) {
                                ForEach(1..<11) { tableValue in
                                    Text("\(tableValue) 초")
                                }
                            }
                            .pickerStyle(.menu)
                            .tint(Color("1F2020"))
                        }
#else
                        Picker("", selection: $pointTableIndex) {
                            ForEach(1..<7) { secondValue in
                                Text("\(secondValue * 10) 초")
                            }
                        }
                        .pickerStyle(.segmented)
                        .tint(Color("1F2020"))
                        .onChange(of: pointTableIndex) { newValue in
                            self.fetchGameResultData(playMode: self.gamePlayMode, playTimeIndex: newValue)
                        }
                        .onAppear {
                            self.pointTableIndex = savedTimeIndex
                        }
#endif
                        ForEach(0..<self.gameResultDatas.count * 50) { index in
                            Text("\(String(format: "%02d", index)).  점수 : \(self.gameResultDatas[0].score)")
                        }
                    }
                }
                Spacer()
            }
            .navigationTitle("점수")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundColor(Color("1F2020"))
                })
            )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text(gamePlayMode.id)
                            .font(.custom("GmarketSansTTFBold", size: 16))
                            .foregroundColor(Color("1F2020"))
                        
                        Image(gamePlayMode == .빗방울 ? "game_play_rain" : "game_play_mole")
                            .resizable()
                            .frame(width: Config.GAME_PLAY_MODE_ICON_SIZE, height: Config.GAME_PLAY_MODE_ICON_SIZE)
                    }
                }
            }
        }
        .onAppear {
            fetchGameResultData(playMode: gamePlayMode, playTimeIndex: pointTableIndex)
        }
    }
    
    func fetchGameResultData(playMode: GamePlayMode, playTimeIndex: Int) {
        self.gameResultDatas = gameViewModel.fetchGamePlayModeResultData(playMode: playMode, playTime: ((playTimeIndex + 1) * 10))
    }
}
