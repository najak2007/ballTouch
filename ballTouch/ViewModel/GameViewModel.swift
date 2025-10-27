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
        gameResultDataArr = Array(results).sorted { $0.score > $1.score }
    }
    
    func gameResultAdd(resultData gameResultData: GameResultData) -> Int {
        guard let realm = realm else { return 0 }
        
        let results = realm.objects(GameResultData.self)
        gameResultDataArr = Array(results).sorted { $0.score > $1.score }
        
        if gameResultDataArr.count >= Config.GAME_RESULT_DATA_MAX_COUNT {
            setGameResultDataDelete(resultData: gameResultDataArr.last)
        }
        
        do {
            try realm.write {
                realm.add(gameResultData)
                fetchGameResultDatas()
                
                if let addIndex = gameResultDataArr.firstIndex(of: gameResultData) {
                    return addIndex
                }
                return 0
            }
        } catch {
        
        }
        return 0
    }
    
    func setGameResultDataDelete(resultData: GameResultData?) {
        guard let realm = realm else { return }
        
        guard let resultData = resultData else { return }
        
        do {
            try realm.write {
                realm.delete(resultData)
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
    
    func setGameResultForPlayNameUpdate(resultData: GameResultData, playName: String, completion: (Bool) -> Void) {
        guard let realm = realm else { return completion(false)}
        let results = realm.objects(GameResultData.self)
        gameResultDataArr = Array(results).sorted { $0.score > $1.score }
        
        do {
            try realm.write {
                if let searchGameResultData = gameResultDataArr.first(where: { $0.date == resultData.date}) {
                    searchGameResultData.playName = playName
                }
                fetchGameResultDatas()
                completion(true)
            }
        } catch {
            completion(false)
        }
    }
}
