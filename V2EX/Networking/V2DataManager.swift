//
//  V2DataManager.swift
//  V2EX
//
//  Created by xushuifeng on 2018/7/28.
//

import Foundation
import AVFoundation
import WCDBSwift

class V2DataManager {
    
    struct Tables {
        static let topic = "tb_topic"
        static let reply = "tb_reply"
    }
    
    static let shared = V2DataManager()
    
    var nodeGroups: [V2NodeGroup] = []
    
    fileprivate let database: Database
    
    fileprivate let queue = DispatchQueue(label: "com.v2ex.datamanager")
    
    private init() {
        let path = NSHomeDirectory().appending("/Documents/v2.sqlite")
        //try? FileManager.default.removeItem(atPath: path)
        database = Database(withPath: path)
        do {
            
            try database.create(table: "topics", of: Topic.self)
            try database.create(table: "reply", of: Reply.self)
        } catch {
            print(error)
        }
    }
    
    func loadTopics(forTab tab: String) -> [Topic] {
        do {
            let condition = Topic.Properties.tab == tab
            let objects: [Topic] = try database.getObjects(fromTable: Tables.topic, where: condition)
            return objects
        } catch {
            print(error)
        }
        return []
    }
    
    func saveTopics(_ topics: [Topic], forTab tab: String) {
        queue.async {
            do {
                let condition = Topic.Properties.tab == tab
                try self.database.delete(fromTable: Tables.topic, where: condition)
                try self.database.insert(objects: topics, intoTable: Tables.topic)
            } catch {
                print(error)
            }
        }
    }
    
}

