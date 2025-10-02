//
//  GameObjectiveView.swift
//  ballTouch
//
//  Created by najak on 10/2/25.
//

import SwiftUI
import Foundation

struct GameObjectiveView: View {
    var selectHandler: ((GameObjective) -> Void)
    
    var body: some View {
        List {
            ForEach(GameObjective.allCases) { objective in
                Button(action: {
                    self.selectHandler(objective)
                }, label: {
                    Text(objective.rawValue)
                        .font(.custom("GmarketSansTTFMedium", size: 20))
                        .foregroundColor(Color("1F2020"))
                })
            }
        }
        .environment(\.defaultMinListRowHeight, 70)
        .scrollDisabled(true)
    }
}
