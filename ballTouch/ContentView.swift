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
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                ImageCircleButton(uiImage: UIImage(systemName: "gamecontroller")! as UIImage, size: $gameStartButtonSize, action: {
                    isGameStart.toggle()
                    HapticManager.instance.notification(type: .success)
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
                    BottomSheetView($isGameObjectiveShow, height: 300) {
                        VStack {
                            GameObjectiveView { objectiveItem in
                                self.selectedGameObjective = objectiveItem
                                self.isGameObjectiveShow.toggle()
                                // self.isObjectiveInputViewShow.toggle()
                                Picker("\(self.selectedGameObjective.id )", selection: $selectedScore) {
                                    ForEach(50..<500) { number in
                                        Text("\(number)").tag(number as Int)
                                    }
                                }
                                .pickerStyle(.wheel)
                            }
                        }
                    }
                }
            }
        }
    }
}
