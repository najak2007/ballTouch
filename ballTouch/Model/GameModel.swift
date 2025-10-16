//
//  GameModel.swift
//  ballTouch
//
//  Created by najak on 10/2/25.
//

import Foundation

enum GameObjective: String, CaseIterable, Identifiable, Decodable, Encodable {
    case 합산_점수
    case 점수_맞추기
    case 시간_설정
    
    var id: String {
        return rawValue.replacingOccurrences(of: "_", with: " ")
    }
}

enum GameState: Decodable, Encodable {
    case 초기화
    case 게임중
    case 일시정지
    case 게임완료
}
