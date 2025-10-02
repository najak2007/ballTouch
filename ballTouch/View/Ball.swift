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
    
    
    init(in geometry: GeometryProxy) {
        position = Ball.getRandomPosition(in: geometry)
        size = CGFloat.random(in: 50...100)
        color = .random
        point = (Int.random(in: 1...10)) * 10
        label = Text(String(point))
    }
    
    mutating func updatePosition(in geometry: GeometryProxy) {
        if !isStopped {
            position = CGPoint(x: position.x, y: position.y + speed)
            
            if !isInside(geometry: geometry) {
                reproduceBall(geometry: geometry)
            }
        }
    }
    
    func isInside(geometry: GeometryProxy) -> Bool {
        let minX = -size
        let maxX = geometry.size.width + size
        let minY = -size
        let maxY = geometry.size.height + size
        
        return (minX...maxX).contains(position.x) && (minY...maxY).contains(position.y)
    }
    
    mutating func reproduceBall(geometry: GeometryProxy) {
        position = Ball.getRandomPosition(in: geometry)
        point = (Int.random(in: 1...10))*10
        size = CGFloat.random(in: 50...100)
        label = Text(String(point))
        color = .random
        touched = false
    }
    
    static func getRandomPosition(in geometry: GeometryProxy) -> CGPoint {
        return CGPoint(x: CGFloat.random(in: 0...geometry.size.width), y: CGFloat.random(in: 0...geometry.size.height / 3))
    }
}
