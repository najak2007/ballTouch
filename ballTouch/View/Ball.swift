//
//  Ball.swift
//  ballTouch
//
//  Created by najak on 10/2/25.
//

import SwiftUI

struct Ball: Identifiable {
    var touched: Bool = false
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
    var color: Color
    var isStopped: Bool = false
    var timer: Timer?
    var point: Int
    var label: Text
    var speed: CGFloat = CGFloat(Int.random(in: 5...15))
    var isAnimating: Bool = false
    var playMode: GamePlayMode = .빗방울
    
    init(in geometry: GeometryProxy, gameMode selectedGameObjective: GameObjective = .합산_점수, playMode gamePlayMode: GamePlayMode = .빗방울) {
        position = Ball.getRandomPosition(in: geometry)
        
        if gamePlayMode == .빗방울 {
            size = CGFloat.random(in: 50...100)
            color = .random
            point = (Int.random(in: 1...10)) * 10
            label = Text(String(point))
        } else {
            size = 0
            color = .clear
            point = (Int.random(in: 1...10)) * 10
            label = Text("")
        }
        
        if selectedGameObjective == .합산_점수 {
            speed = CGFloat(Int.random(in: 5...15))
        } else {
            speed = CGFloat(Int.random(in: 2...6))
        }
        
        playMode = gamePlayMode
    }
    
    mutating func updatePosition(in geometry: GeometryProxy, ballIndex: Int = 0) {
        if !isStopped {
            if playMode == .빗방울 {
                position = CGPoint(x: position.x, y: position.y + speed)
            } else {
                if size == 0 {
                    reproduceBall(geometry: geometry, ballIndex: ballIndex)
                } else {
                    size = 0
                    label = Text("")
                }
            }
            
            if !isInside(geometry: geometry) {
                reproduceBall(geometry: geometry)
            }
        }
    }
    
    func isInside(geometry: GeometryProxy) -> Bool {
        let minX = -(size * 1.6)
        let maxX = geometry.size.width + size
        let minY = -size
        let maxY = geometry.size.height + size
        
        return (minX...maxX).contains(position.x) && (minY...maxY).contains(position.y)
    }
    
    mutating func reproduceBall(geometry: GeometryProxy, ballIndex: Int = 0) {
        position = Ball.getRandomPosition(in: geometry, playMode: playMode)
        if playMode == .빗방울 {
            point = (Int.random(in: 1...10))*10
        } else if playMode == .두더지 {
            switch (ballIndex % Config.GAME_PLAY_MODE_MOLE_COUNT) {
            case 0:
                point = (Int.random(in: 1...4))*10
            case 1:
                point = (Int.random(in: 5...7))*10
            case 2:
                point = (Int.random(in: 8...10))*10
            default:
                point = (Int.random(in: 1...10))*10
            }
        }
        size = CGFloat.random(in: 50...100)
        label = Text(String(point))
        color = .random
        touched = false
    }
    
    mutating func setBallZeroSize() {
        if playMode == .두더지 {
            size = 0
            label = Text("")
        }
    }
    
    static func getRandomPosition(in geometry: GeometryProxy, playMode: GamePlayMode = .빗방울) -> CGPoint {
        if playMode == .빗방울 {
            return CGPoint(x: CGFloat.random(in: 0...geometry.size.width), y: CGFloat.random(in: 0...geometry.size.height / 3))
        }
        return CGPoint(x: CGFloat.random(in: 0...geometry.size.width), y: CGFloat.random(in: 0...geometry.size.height))
    }
}
