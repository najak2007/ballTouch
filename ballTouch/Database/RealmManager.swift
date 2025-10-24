//
//  RealmManager.swift
//  ballTouch
//
//  Created by najak on 10/24/25.
//

import RealmSwift
import Foundation

class RealmManager {
    static let shared = RealmManager()
    private init() {}
    
    var realm: Realm {
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.co.kr.oceanbleu")
        let realmURL = container?.appendingPathComponent("oceanbleuballTouch.realm")
        
        let config = Realm.Configuration(fileURL: realmURL, schemaVersion: 1)
        return try! Realm(configuration: config)
    }
    
    static func getNewRealmID(prefixStr: String = "") -> String {
        let date: Date = Date()
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let nowID: String = "\(prefixStr)\(dateFormatter.string(from: date))"
        return nowID
    }
}
