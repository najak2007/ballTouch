//
//  GameScoreRowView.swift
//  ballTouch
//
//  Created by najak on 10/25/25.
//

import SwiftUI
import Foundation

struct GameScoreRowView: View {
    
    var gameResultData: GameResultData
    @State private var gamePlayerName: String = ""
    var rankIndex: Int
    @State var addGameResultDatas: [GameResultData] = []
    
    @State private var isAddGameResult: Bool = false
    @State private var isAnimating: Bool = false
    
    var inputHandler: (GameResultData, String) -> Void
    var inputErrorHandler: (InputTypeError) -> Void
    
    var body: some View {
        HStack {
            Text(setRankAttributedString((String(format: "%02d", rankIndex)), commentLabel: "위"))
                .monospacedDigit()
                .frame(width: 60)
            Spacer()
            
            if self.isAddGameResult {
                Text(setRankAttributedString((setCommaChange(gameResultData.score)), commentLabel: "점"))
                    .monospacedDigit()
                    .frame(width: 120)
                    .underline()
            } else {
                Text(setRankAttributedString((setCommaChange(gameResultData.score)), commentLabel: "점"))
                    .monospacedDigit()
                    .frame(width: 120)
            }
            
            Spacer()
            
            TextField("이름 입력", text: $gamePlayerName)
                .font(.custom("GmarketSansTTFMedium", size: 18))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .frame(width: 140)
                .submitLabel(.done)
                .onSubmit {
                    let trimWhiteSpace = gamePlayerName.trimmingCharacters(in: .whitespacesAndNewlines)
                    self.gamePlayerName = trimWhiteSpace
                    
                    if self.gamePlayerName.isEmpty {
                        inputErrorHandler(.이름_미입력)
                        return
                    }
                    
                    if self.gamePlayerName.count > Config.GAME_PLAYER_NAME_COUNT {
                        inputErrorHandler(.이름_글자갯수)
                        return
                    }
                    
                    inputHandler(self.gameResultData, self.gamePlayerName)
                }
        }
        .onAppear {
            self.gamePlayerName = gameResultData.playName
            self.isAddGameResult = addGameDataForResult(gameResultData)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 5)
    }
    
    func setCommaChange(_ intValue: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: intValue)) ?? String(format: "%02d", intValue)
    }
    
    func setRankAttributedString(_ title: String, commentLabel: String) -> AttributedString {
        var attributedString = AttributedString("\(title) \(commentLabel)")
        
        if let fullRange = attributedString.range(of: "\(title) \(commentLabel)") {
            attributedString[fullRange].foregroundColor = Color("1F2020")
            attributedString[fullRange].font = .custom(isAddGameResult == false ? "GmarketSansTTFMedium" : "GmarketSansTTFBold", size: isAddGameResult == false ? 18 : 22)
            attributedString[fullRange].underlineColor = isAddGameResult == false ? .clear : .red
        }
        
        if let rankLabelRange = attributedString.range(of: "\(commentLabel)") {
            attributedString[rankLabelRange].foregroundColor = Color("1F2020").opacity(0.6)
            attributedString[rankLabelRange].font = .custom(isAddGameResult == false ? "GmarketSansTTFMedium" : "GmarketSansTTFBold", size: isAddGameResult == false ? 16 : 20)
        }
        return attributedString
    }
    
    func addGameDataForResult(_ rowItemData: GameResultData) -> Bool {
        if addGameResultDatas.count == 0 {
            return false
        }
        
        for index in 0..<addGameResultDatas.count {
            let addItemData = addGameResultDatas[index]
            
            if rowItemData.date == addItemData.date,
               rowItemData.score == addItemData.score,
               rowItemData.gameGroupID == addItemData.gameGroupID {
                return true
            }
        }
        return false
    }
}
