//
//  GameScoreRowView.swift
//  ballTouch
//
//  Created by najak on 10/25/25.
//

import SwiftUI
import Foundation

struct GameScoreRowView: View {
    
    @Binding var gameResultData: GameResultData
    @State private var gamePlayerName: String = ""
    var rankIndex: Int
    
    var body: some View {
        HStack {
            Text("\(String(format: "%02d", rankIndex))")
                .font(.custom("GmarketSansTTFMedium", size: 22))
                .foregroundColor(Color("1F2020"))
                .monospacedDigit()
            
            Spacer()
            
            Text("\(gameResultData.score)")
                .font(.custom("GmarketSansTTFMedium", size: 22))
                .foregroundColor(Color("1F2020"))
                .monospacedDigit()
            
            Spacer()
            
            TextField("", text: $gamePlayerName)
                .font(.custom("GmarketSansTTFMedium", size: 22))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
    }
}
