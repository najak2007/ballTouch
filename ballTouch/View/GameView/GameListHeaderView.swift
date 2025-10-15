//
//  GameListHeaderView.swift
//  ballTouch
//
//  Created by najak on 10/15/25.
//

import SwiftUI

enum HeaderTextAlignment {
    case 좌측정렬
    case 가운데정렬
    case 우측정렬
}

struct GameListHeaderView: View {
    var headerText: String
    var showAlignments: HeaderTextAlignment
    
    var body: some View {
        HStack {
            if showAlignments == .우측정렬 || showAlignments == .가운데정렬 {
                Spacer()
            }
            
            Text(headerText)
                .font(.custom("GmarketSansTTFLight", size: Config.INPUT_VIEW_HEADER_FONT_SIZE))
                .foregroundColor(Color("1F2020"))
            
            if showAlignments == .좌측정렬 || showAlignments == .가운데정렬 {
                Spacer()
            }
        }
    }
}
