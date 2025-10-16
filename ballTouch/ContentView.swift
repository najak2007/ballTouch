//
//  ContentView.swift
//  ballTouch
//
//  Created by najak on 10/1/25.
//

import SwiftUI

struct ContentView: View {
    @State private var gameStartButtonSize: CGFloat = Config.GAME_START_BUTTON_SIZE
    @State private var isGameStart: Bool = false
    @State private var isGameObjectiveShow: Bool = false
    @State private var selectedGameObjective: GameObjective = .합산_점수
    @State private var isObjectiveInputViewShow: Bool = false
    @State private var selectedScore: Int = 50
    @State private var savedScoreIndex: Int = 4
    @State private var savedTimeIndex: Int = 2

    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    HStack(spacing: 5) {
                        Text(selectedGameObjective.id)
                            .font(.custom("GmarketSansTTFBold", size: 16))
                            .foregroundColor(Color("1F2020"))
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 5) {
                        Image(systemName: "timer.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                            
#if true
                        Menu(selectionIndex: $savedTimeIndex) { selectionIndex in
                            savedTimeIndex = selectionIndex
                        }.frame(width: 50, height: 25)
#else
                        Menu("안녕" /*"\((savedTimeIndex + 1) * 10)초" */) {
                            ForEach(0..<10) { number in
                                Button(action: {
                                    savedTimeIndex = number
                                }, label: {
                                    Text("\((number + 1) * 10)초")
                                        .font(.custom("GmarketSansTTFBold", size: 16))
                                        .foregroundColor(Color("1F2020"))
                                })
                            }
                        }
                        .font(.custom("GmarketSansTTFMedium", size: 14))
                        .foregroundColor(Color("1F2020").opacity(06))
#endif
                    }
                }
                .frame(height: Config.NAVIGATION_HEIGHT)
                .padding(.horizontal, 20)
                
                Spacer()
                
                Button(action: {
                    isGameStart.toggle()
                    HapticManager.instance.notification(type: .success)
                }, label: {
                    Image(systemName: "play.square.fill")
                        .resizable()
                        .frame(width: Config.GAME_START_BUTTON_SIZE, height: Config.GAME_START_BUTTON_SIZE)
                        .foregroundColor(Color("1F2020"))
                })
                
                Spacer()

                RoundedButton(title: "Game 설정", action: {
                    isGameObjectiveShow.toggle()
                })
                .padding(.bottom, 50)
            }
            .fullScreenCover(isPresented: $isObjectiveInputViewShow) {
                ObjectiveInputView(selectedGameObjective: $selectedGameObjective)
                
            }
        }
        .overlay {
            ZStack(alignment: .bottom) {
                Color.black.opacity(0.1).opacity(isGameObjectiveShow ? 1 : 0)
                    .onTapGesture {
                        self.isGameObjectiveShow.toggle()
                    }
                
                if self.isGameObjectiveShow {
                    BottomSheetView($isGameObjectiveShow, height: 350) {
                        VStack {
                            GameObjectiveView(selectedGameObjective: $selectedGameObjective, savedScoreIndex: $savedScoreIndex, savedTimeIndex: $savedTimeIndex) { objectiveItem, objectiveValue in
                                self.selectedGameObjective = objectiveItem
                                self.isGameObjectiveShow.toggle()

                            }
                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $isGameStart, onDismiss: {
            
        }) {
            GamePlayView(selectedGameObjective: $selectedGameObjective, savedScoreIndex: $savedScoreIndex, savedTimeIndex: $savedTimeIndex)
        }
    }
}
