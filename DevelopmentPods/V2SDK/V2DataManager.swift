//
//  V2DataManager.swift
//  V2SDK
//
//  Created by xushuifeng on 2018/7/28.
//

import Foundation
import SQLiteKit

public class V2DataManager {
    
    public static let shared = V2DataManager()
    
    fileprivate var db: SQLiteConnection?
    
    init() {
        let path = NSHomeDirectory().appending("/Documents/db.sqlite")
        try? FileManager.default.removeItem(atPath: path)
        do {
            db = try SQLiteConnection(databasePath: path)
            try db?.createTable(Reply.self)
        } catch {
            print(error)
        }
    }
    
    public func loadTopics() {
        
    }
    
    func saveTopics() {
        
    }
    
}
