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
    @Binding var scrollPosition: Int
    
    @State private var scoreTableIndex: Int = 0
    
    @ObservedObject var gameViewModel = GameViewModel()
    @State private var gameResultDatas: [GameResultData] = []
    @State private var tableCount: Int = 0
    @State private var toast: Toast? = nil
    
    @State private var currentVisibleItem: GameResultData?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
#if true
                Picker("", selection: $scoreTableIndex) {
                    ForEach(1..<7) { secondValue in
                        Text("\(secondValue * 10) 초")
                    }
                }
                .pickerStyle(.segmented)
                .tint(Color("1F2020"))
                .onChange(of: scoreTableIndex) { oldValue, newValue in
                    if oldValue != newValue {
                        self.fetchGameResultData(playMode: self.gamePlayMode, playTimeIndex: newValue)
                    }
                }
                .onAppear {
                    self.scoreTableIndex = savedTimeIndex
                }
                
                ScrollView {
                    LazyVStack {
                        ForEach(0..<tableCount, id:\.self) { index in
                            GameScoreRowView(gameResultData: self.gameResultDatas[index], rankIndex: (index + 1),  inputHandler: { (gameResultData, playName) in
                                gameViewModel.setGameResultForPlayNameUpdate(resultData: gameResultData, playName: playName) { isCompletion in
                                    fetchGameResultData(playMode: gamePlayMode, playTimeIndex: scoreTableIndex)
                                }
                            }, inputErrorHandler: { errorType in
                                inputErrorHandler(errorType)
                            })
                            .id(index)
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollPosition(id: $currentVisibleItem, anchor: .bottom)
#else
                List {
                    Section {
#if __NOT_USE__
                        if self.selectedGameObjective == .합산_점수 {
                            Picker("", selection: $scoreTableIndex) {
                                if self.selectedGameObjective == .합산_점수 {
                                    ForEach(1..<7) { tableValue in
                                        Text("\(tableValue) 초")
                                    }
                                }
                            }
                            .pickerStyle(.segmented)
                        } else {
                            Picker("", selection: $scoreTableIndex) {
                                ForEach(1..<11) { tableValue in
                                    Text("\(tableValue) 초")
                                }
                            }
                            .pickerStyle(.menu)
                            .tint(Color("1F2020"))
                        }
#else
                        Picker("", selection: $scoreTableIndex) {
                            ForEach(1..<7) { secondValue in
                                Text("\(secondValue * 10) 초")
                            }
                        }
                        .pickerStyle(.segmented)
                        .tint(Color("1F2020"))
                        .onChange(of: scoreTableIndex) { oldValue, newValue in
                            if oldValue != newValue {
                                self.fetchGameResultData(playMode: self.gamePlayMode, playTimeIndex: newValue)
                            }
                        }
                        .onAppear {
                            self.scoreTableIndex = savedTimeIndex
                        }
#endif
                        ForEach(0..<tableCount, id:\.self) { index in
                            GameScoreRowView(gameResultData: self.gameResultDatas[index], rankIndex: (index + 1),  inputHandler: { (gameResultData, playName) in
                                gameViewModel.setGameResultForPlayNameUpdate(resultData: gameResultData, playName: playName) { isCompletion in
                                    fetchGameResultData(playMode: gamePlayMode, playTimeIndex: scoreTableIndex)
                                }
                            }, inputErrorHandler: { errorType in
                                inputErrorHandler(errorType)
                            })
                            .id(index)
                        }
                    }
                }
#endif
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
            fetchGameResultData(playMode: gamePlayMode, playTimeIndex: scoreTableIndex)
        }
    }
    
    func fetchGameResultData(playMode: GamePlayMode, playTimeIndex: Int) {
        self.gameResultDatas = gameViewModel.fetchGamePlayModeResultData(playMode: playMode, playTime: ((playTimeIndex + 1) * 10))
        self.tableCount = self.gameResultDatas.count
    }
    
    func inputErrorHandler(_ inputError: InputTypeError) {
        switch inputError {
        case .이름_글자갯수:
            toast = Toast(type: .error, title: "", message: "이름은 \(Config.GAME_PLAYER_NAME_COUNT)자 이내로 입력해주세요.")
        case .이름_미입력:
            toast = Toast(type: .error, title: "", message: "1글자 이상 입력해주세요.")
        }
    }
}
