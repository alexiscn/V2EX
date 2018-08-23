//
//  V2DataManager.swift
//  V2SDK
//
//  Created by xushuifeng on 2018/7/28.
//

import Foundation
import AVFoundation
import SQLiteKit

public class V2DataManager {
    
    public static let shared = V2DataManager()
    
    public var nodeGroups: [V2NodeGroup] = []
    
    fileprivate var db: SQLiteConnection!
    
    fileprivate let queue = DispatchQueue(label: "com.v2ex.datamanager")
    
    init() {
        let path = NSHomeDirectory().appending("/Documents/db.sqlite")
        //try? FileManager.default.removeItem(atPath: path)
        do {
            db = try SQLiteConnection(databasePath: path)
            try db.createTable(Topic.self)
            try db.createTable(Reply.self)
        } catch {
            print(error)
        }
    }
    
    public func loadTopics(forTab tab: String) -> [Topic] {
        let tableQuery: TableQuery<Topic> = db.table(of: Topic.self)
        return tableQuery.toList()
    }
    
    func saveTopics(_ topics: [Topic], forTab tab: String) {
        if db == nil {
            return
        }
        
        queue.async {
            do {
                try self.db.delete(using: NSPredicate(format: "tab=%@", tab), on: Topic.self)
                try self.db.insertAll(topics)
            } catch {
                print(error)
            }
        }
    }
    
}
