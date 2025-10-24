//
//  GameViewModel.swift
//  ballTouch
//
//  Created by najak on 10/24/25.
//

import Foundation
import SwiftUI
import RealmSwift
import Combine

class GameViewModel: NSObject, ObservableObject {
    
    static let shared = GameViewModel()
    
    private var realm: Realm?
    
    @Published var gameResultDataArr: [GameResultData] = []
    
    override init() {
        super.init()
        
        do {
            realm = try Realm()
            fetchGameResultDatas()
        } catch {
            
        }
    }
    
    func fetchGameResultDatas() {
        guard let realm = realm else { return }
        let results = realm.objects(GameResultData.self)
        gameResultDataArr = Array(results)
    }
    
    func gameResultAdd(resultData gameResultData: GameResultData) {
        guard let realm = realm else { return }
        
        do {
            try realm.write {
                realm.add(gameResultData)
                fetchGameResultDatas()
            }
        } catch {
            
        }
    }
    
    func fetchGamePlayModeResultData(playMode gamePlayMode: GamePlayMode = .빗방울, playTime gamePlaySecond: Int = 20) -> [GameResultData] {
        if gameResultDataArr.count == 0 {
            return []
        }
        let fetchGameDatas = gameResultDataArr.filter({$0.gamePlayMode == gamePlayMode && $0.gamePlaySecond == gamePlaySecond })
        return fetchGameDatas
    }
}
