//
//  GameModel.swift
//  ballTouch
//
//  Created by najak on 10/2/25.
//

import Foundation
import RealmSwift
internal import Realm

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

enum GamePlayMode: String, CaseIterable, Identifiable, Decodable, Encodable {
    case 빗방울
    case 두더지

    var id: String {
        return rawValue
    }
}

class GameResultData: Object {
    @objc dynamic var date: Date = Date()
    @objc dynamic var gameGroupID: String = ""
    @objc dynamic var score: Int = 0
    dynamic var gamePlayMode: GamePlayMode = .빗방울
    @objc dynamic var gamePlaySecond: Int = 10
    @objc dynamic var playName: String = ""
    
    override init() {
        super.init()
    }
    
    init(date: Date, gameGroupID: String, score: Int, gamePlayMode: GamePlayMode, gamePlaySecond: Int, playName: String = "") {
        self.date = date
        self.gameGroupID = gameGroupID
        self.score = score
        self.gamePlayMode = gamePlayMode
        self.gamePlaySecond = gamePlaySecond
        self.playName = playName
    }
}
